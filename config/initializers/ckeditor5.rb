CKEditor5::Rails.configure do
  # 🔖 Specify the version of editor you want.
  # ⚙️ Default configuration includes:
  #    📝 Classic editor build
  #    🧩 Essential plugins (paragraphs, basic styles)
  #    🎛️ Default toolbar layout
  #    📜 GPL license

  # Optionally, you can specify version of CKEditor 5 to use.
  # If it's not specified the default version specified in the gem will be used.
  # version '48.0.1'

  # Upload images to the server using the simple upload adapter, instead of Base64 encoding.
  # simple_upload_adapter

  # Specify global language for the editor.
  # It can be done here, in controller or in the view.
  # By default the `I18n.locale` is used.
  # language :pl
  toolbar :heading, :bold, :italic, :underline, :|, :link, :bulletedList, :numberedList, :|, :blockQuote
end
