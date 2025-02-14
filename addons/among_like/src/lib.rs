use godot::classes::HBoxContainer;
use godot::classes::IHBoxContainer;
use godot::prelude::*;

struct MyExtension;

#[gdextension]
unsafe impl ExtensionLibrary for MyExtension {}

/// Message displayed in chat window
#[derive(GodotClass)]
#[class(base=HBoxContainer)]
struct ChatMessage {
    display_name: GString,
    message: GString,
    base: Base<HBoxContainer>,
}

#[godot_api]
impl IHBoxContainer for ChatMessage {
    fn init(base: Base<HBoxContainer>) -> Self {
        Self {
            display_name: "Josh".to_godot(),
            message: "Sup?".to_godot(),
            base,
        }
    }
}
