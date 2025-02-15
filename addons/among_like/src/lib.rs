use godot::classes::control::SizeFlags;
use godot::classes::text_server::AutowrapMode;
use godot::classes::HBoxContainer;
use godot::classes::Label;
use godot::prelude::*;

struct MyExtension;

#[gdextension]
unsafe impl ExtensionLibrary for MyExtension {}

const DISPLAY_NAME_COLOR: Color = Color::from_rgb(0.695503, 0.695503, 0.695503);

/// Message displayed in chat window
#[derive(GodotClass)]
#[class(no_init, base=HBoxContainer)]
struct ChatMessage {
    /// Name indicating who sent the message
    display_name: Option<GString>,
    /// Message content of Chat Message
    #[var]
    message: GString,

    base: Base<HBoxContainer>,
}

#[godot_api]
impl ChatMessage {
    /// Create a Chat Message with a `display_name`
    /// ```gdscript
    /// var msg = ChatMessage.from("Josh", "Sup?")
    /// # <Josh> Sup?
    /// ````
    #[func]
    fn from(display_name: GString, message: GString) -> Gd<Self> {
        let mut display_name_label = Label::new_alloc();
        display_name_label.set_name("display_name");
        display_name_label.set_text(&format!("<{}>", &display_name));
        display_name_label.set_modulate(DISPLAY_NAME_COLOR);
        display_name_label.set_v_size_flags(SizeFlags::SHRINK_BEGIN);

        let mut message_label = Label::new_alloc();
        message_label.set_name("message_label");
        message_label.set_text(&message);
        message_label.set_h_size_flags(SizeFlags::EXPAND_FILL);
        message_label.set_autowrap_mode(AutowrapMode::WORD_SMART);

        let mut chat_message = Gd::from_init_fn(|base| Self {
            message,
            display_name: Some(display_name),
            base,
        });

        chat_message.add_child(&display_name_label);
        chat_message.add_child(&message_label);
        chat_message
    }

    /// Create a Chat Message with no `display_name`
    /// ```gdscript
    /// var msg = ChatMessage.new("New Round Is Starting...")
    /// # New Round Is Starting...
    #[func]
    fn create(message: GString) -> Gd<Self> {
        let mut message_label = Label::new_alloc();
        message_label.set_name("message_label");
        message_label.set_text(&message);
        message_label.set_modulate(DISPLAY_NAME_COLOR);
        // message_label.layout_mode = 2;
        // message_label.size_flags_horizontal = 3;
        // message_label.autowrap_mode = 3;

        let mut system_message = Gd::from_init_fn(|base| Self {
            message,
            display_name: None,
            base,
        });

        system_message.add_child(&message_label);
        system_message
    }
}
