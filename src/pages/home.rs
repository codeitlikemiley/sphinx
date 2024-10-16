use leptos::*;
use leptos_router::*;

/// Renders the home page of your application.
#[component]
pub fn Home() -> impl IntoView {
    // Creates a reactive value to update the button
    let counter = create_server_action::<UpdateCount>();

    let count = create_resource(move || (counter.version().get(),), |_| get_count());

    view! {
        <div class="flex flex-col items-center justify-center">
            <h1 class="text-5xl text-pink-500 hover:text-pink-700">"Uriah"</h1>

            <ActionForm action=counter>
                <button class="bg-purple-500 hover:bg-purple-700 text-white font-bold py-2 px-4 rounded">
                    "Click Me: " {move || count.get()}
                </button>
            </ActionForm>

        </div>
    }
}

#[server]
pub async fn update_count() -> Result<(), ServerFnError> {
    println!("Upated count");

    let store = spin_sdk::key_value::Store::open_default()?;

    let count: u64 = store
        .get_json("sphinx_count")
        .map_err(|e| ServerFnError::new(e))?
        .unwrap_or_default();

    let updated_count = count + 1;

    store
        .set_json("sphinx_count", &updated_count)
        .map_err(|e| ServerFnError::new(e))?;
    Ok(())
}

#[server]
pub async fn get_count() -> Result<u64, ServerFnError> {
    let store = spin_sdk::key_value::Store::open_default()?;

    let stored_count: u64 = store
        .get_json("sphinx_count")
        .map_err(|e| ServerFnError::new(e))?
        .ok_or_else(|| ServerFnError::new("No stored count found, please increment first"))?;

    println!("Got stored {stored_count}");

    Ok(stored_count)
}
