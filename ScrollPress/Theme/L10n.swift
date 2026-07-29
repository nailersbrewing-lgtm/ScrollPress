import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case spanish = "es"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Español"
        }
    }

    var shortCode: String {
        switch self {
        case .english: return "EN"
        case .spanish: return "ES"
        }
    }

    mutating func toggle() {
        self = self == .english ? .spanish : .english
    }

    var switched: AppLanguage {
        self == .english ? .spanish : .english
    }
}

enum L10n {
    /// Exact language only — no English fallback. Missing keys show as `[key]`.
    static func t(_ key: String, _ language: AppLanguage) -> String {
        guard let entry = strings[key], let value = entry[language] else {
            return "[\(key)]"
        }
        return value
    }

    private static let strings: [String: [AppLanguage: String]] = [
        // Step titles
        "step.welcome": [.english: "Welcome", .spanish: "Inicio"],
        "step.nameThread": [.english: "Label", .spanish: "Etiqueta"],
        "step.captureGuide": [.english: "Capture", .spanish: "Captura"],
        "step.importMedia": [.english: "Import", .spanish: "Importar"],
        "step.processing": [.english: "Reading", .spanish: "Leyendo"],
        "step.review": [.english: "Review", .spanish: "Revisar"],
        "step.export": [.english: "Print", .spanish: "Imprimir"],

        // Help balloon titles
        "help.welcome.title": [
            .english: "What ScrollPress does",
            .spanish: "Qué hace ScrollPress"
        ],
        "help.nameThread.title": [
            .english: "Name this printout",
            .spanish: "Nombra esta impresión"
        ],
        "help.captureGuide.title": [
            .english: "How to capture the chat",
            .spanish: "Cómo capturar el chat"
        ],
        "help.importMedia.title": [
            .english: "Bring your capture in",
            .spanish: "Trae tu captura"
        ],
        "help.processing.title": [
            .english: "Reading the text",
            .spanish: "Leyendo el texto"
        ],
        "help.review.title": [
            .english: "Check before printing",
            .spanish: "Revisa antes de imprimir"
        ],
        "help.export.title": [
            .english: "Save or print for free",
            .spanish: "Guarda o imprime gratis"
        ],

        // Help balloon bodies
        "help.welcome.body": [
            .english: "ScrollPress never opens Messages. You capture what you can see (screen recording or screenshots), then we turn it into a printable PDF — free for everyone.",
            .spanish: "ScrollPress nunca abre Mensajes. Tú capturas lo que ves (grabación de pantalla o capturas), y lo convertimos en un PDF para imprimir — gratis para todos."
        ],
        "help.nameThread.body": [
            .english: "Paste or type the phone number or contact name. This only labels your PDF so you can find it later.",
            .spanish: "Pega o escribe el número o el nombre del contacto. Solo etiqueta tu PDF para que lo encuentres después."
        ],
        "help.captureGuide.body": [
            .english: "Open Control Center → Screen Recording. Switch to Messages, open the thread, then scroll slowly from oldest to newest. Stop recording when done.",
            .spanish: "Abre el Centro de control → Grabación de pantalla. Ve a Mensajes, abre el hilo y desplázate despacio de lo más antiguo a lo más nuevo. Detén la grabación al terminar."
        ],
        "help.importMedia.body": [
            .english: "Pick the screen recording video, or select overlapping screenshots of the same thread. More frames = better results.",
            .spanish: "Elige el video de la grabación de pantalla, o selecciona capturas que se solapen del mismo hilo. Más imágenes = mejor resultado."
        ],
        "help.processing.body": [
            .english: "We’re reading text from your capture on this iPhone. Nothing is uploaded. This can take a minute for long threads.",
            .spanish: "Estamos leyendo el texto de tu captura en este iPhone. No se sube nada. En hilos largos puede tardar un minuto."
        ],
        "help.review.body": [
            .english: "Fix any typos, flip Sent/Received if a bubble landed on the wrong side, then continue when it looks right.",
            .spanish: "Corrige errores, cambia Enviado/Recibido si una burbuja quedó del lado equivocado, y continúa cuando se vea bien."
        ],
        "help.export.body": [
            .english: "Create a free PDF, then Print, AirDrop, Mail, or Save to Files. No account. No paywall.",
            .spanish: "Crea un PDF gratis, luego Imprimir, AirDrop, Mail o Guardar en Archivos. Sin cuenta. Sin pagos."
        ],

        // Extra tip balloons
        "tip.paste.title": [
            .english: "Quick tip",
            .spanish: "Consejo rápido"
        ],
        "tip.paste.body": [
            .english: "In Messages, long-press the contact name or number → Copy, then tap Paste here.",
            .spanish: "En Mensajes, mantén pulsado el nombre o número → Copiar, luego toca Pegar aquí."
        ],
        "tip.screenshots.title": [
            .english: "Prefer screenshots?",
            .spanish: "¿Prefieres capturas?"
        ],
        "tip.screenshots.body": [
            .english: "Take overlapping screenshots while you scroll. Later, select all of them in Import. Screen recording is usually faster for long chats.",
            .spanish: "Toma capturas que se solapen mientras te desplazas. Luego selecciónalas todas en Importar. La grabación de pantalla suele ser más rápida en chats largos."
        ],
        "tip.lookingGood.title": [
            .english: "Looking good",
            .spanish: "Va bien"
        ],
        "tip.lookingGood.body": [
            .english: "You added %d frame(s). Tap Read text when ready. You can clear and re-import if you picked the wrong items.",
            .spanish: "Agregaste %d imagen(es). Toca Leer texto cuando estés listo. Puedes borrar e importar de nuevo si elegiste mal."
        ],
        "tip.print.title": [
            .english: "Printing tip",
            .spanish: "Consejo para imprimir"
        ],
        "tip.print.body": [
            .english: "After you create the PDF, choose Print for AirPrint, or Save to Files to keep a copy. You can also Mail or AirDrop it.",
            .spanish: "Después de crear el PDF, elige Imprimir (AirPrint) o Guardar en Archivos. También puedes enviarlo por Mail o AirDrop."
        ],

        // Capture guide cards
        "guide.record.title": [.english: "Record", .spanish: "Grabar"],
        "guide.record.body": [
            .english: "Open Control Center and tap Screen Recording.",
            .spanish: "Abre el Centro de control y toca Grabación de pantalla."
        ],
        "guide.open.title": [.english: "Open chat", .spanish: "Abrir chat"],
        "guide.open.body": [
            .english: "Go to Messages and open the conversation.",
            .spanish: "Ve a Mensajes y abre la conversación."
        ],
        "guide.scroll.title": [.english: "Scroll slow", .spanish: "Desplázate despacio"],
        "guide.scroll.body": [
            .english: "Start near the oldest messages. Scroll slowly to the newest.",
            .spanish: "Empieza cerca de los mensajes más antiguos. Desplázate despacio hasta los más nuevos."
        ],
        "guide.stop.title": [.english: "Stop", .spanish: "Detener"],
        "guide.stop.body": [
            .english: "Open Control Center again and stop the recording.",
            .spanish: "Abre otra vez el Centro de control y detén la grabación."
        ],

        // UI chrome
        "ui.help": [.english: "Help", .spanish: "Ayuda"],
        "ui.language": [.english: "Language", .spanish: "Idioma"],
        "ui.switchToSpanish": [.english: "Español", .spanish: "Español"],
        "ui.switchToEnglish": [.english: "English", .spanish: "English"],
        "ui.languageButtonHint": [
            .english: "Switch language",
            .spanish: "Cambiar idioma"
        ],
        "ui.tagline": [
            .english: "Scroll your chat. Press print.",
            .spanish: "Desplázate por el chat. Imprime."
        ],
        "ui.freeLine": [
            .english: "Free for every iPhone user. No account. No subscriptions.",
            .spanish: "Gratis para todo usuario de iPhone. Sin cuenta. Sin suscripciones."
        ],
        "ui.feature1": [
            .english: "Capture the thread on your screen",
            .spanish: "Captura el hilo en tu pantalla"
        ],
        "ui.feature2": [
            .english: "ScrollPress reads the text on-device",
            .spanish: "ScrollPress lee el texto en tu iPhone"
        ],
        "ui.feature3": [
            .english: "Review bubbles, then print a free PDF",
            .spanish: "Revisa las burbujas y luego imprime un PDF gratis"
        ],
        "ui.start": [.english: "Start — it’s free", .spanish: "Empezar — es gratis"],
        "ui.next": [.english: "Next", .spanish: "Siguiente"],
        "ui.back": [.english: "Back", .spanish: "Atrás"],
        "ui.paste": [.english: "Paste", .spanish: "Pegar"],
        "ui.captured": [.english: "I’ve captured it", .spanish: "Ya lo capturé"],
        "ui.addScreenshots": [.english: "Add screenshots", .spanish: "Agregar capturas"],
        "ui.addScreenshotsSub": [
            .english: "Pick one or many Photos screenshots",
            .spanish: "Elige una o varias capturas de Fotos"
        ],
        "ui.addVideo": [.english: "Add screen recording", .spanish: "Agregar grabación"],
        "ui.addVideoSub": [
            .english: "We’ll sample frames and read the text",
            .spanish: "Tomaremos fotogramas y leeremos el texto"
        ],
        "ui.readText": [.english: "Read text", .spanish: "Leer texto"],
        "ui.clearImports": [.english: "Clear imports", .spanish: "Borrar importados"],
        "ui.processingTitle": [
            .english: "Reading your capture",
            .spanish: "Leyendo tu captura"
        ],
        "ui.processingPct": [
            .english: "%d%% • All processing stays on this iPhone",
            .spanish: "%d%% • Todo el proceso queda en este iPhone"
        ],
        "ui.reviewTitle": [.english: "Review bubbles", .spanish: "Revisar burbujas"],
        "ui.messagesFound": [
            .english: "%d messages found for “%@”",
            .spanish: "%d mensajes encontrados para “%@”"
        ],
        "ui.looksGood": [.english: "Looks good", .spanish: "Se ve bien"],
        "ui.printTitle": [.english: "Print or share", .spanish: "Imprimir o compartir"],
        "ui.messagesReady": [
            .english: "%d messages ready",
            .spanish: "%d mensajes listos"
        ],
        "ui.createPDF": [.english: "Create free PDF", .spanish: "Crear PDF gratis"],
        "ui.startAnother": [
            .english: "Start another thread",
            .spanish: "Empezar otro hilo"
        ],
        "ui.backToReview": [
            .english: "Back to review",
            .spanish: "Volver a revisar"
        ],
        "ui.labelTitle": [
            .english: "Label this printout",
            .spanish: "Etiqueta esta impresión"
        ],
        "ui.captureTitle": [
            .english: "Capture the thread",
            .spanish: "Captura el hilo"
        ],
        "ui.importTitle": [
            .english: "Import your capture",
            .spanish: "Importa tu captura"
        ],
        "ui.placeholderLabel": [
            .english: "Phone number or contact name",
            .spanish: "Número o nombre del contacto"
        ],
        "ui.youSent": [.english: "You sent", .spanish: "Tú enviaste"],
        "ui.theySent": [.english: "They sent", .spanish: "Ellos enviaron"],
        "ui.flipSide": [.english: "Flip side", .spanish: "Cambiar lado"],
        "ui.remove": [.english: "Remove", .spanish: "Quitar"],
        "ui.loadingVideo": [
            .english: "Loading video frames…",
            .spanish: "Cargando fotogramas…"
        ],
        "ui.alertTitle": [.english: "Need a moment", .spanish: "Un momento"],
        "ui.ok": [.english: "OK", .spanish: "OK"],
        "error.needLabel": [
            .english: "Add a contact name or phone number so your PDF has a clear label.",
            .spanish: "Agrega un nombre o número para que el PDF tenga una etiqueta clara."
        ],
        "error.nothingToExport": [
            .english: "Nothing to export yet. Go back and import a capture.",
            .spanish: "Aún no hay nada que exportar. Vuelve e importa una captura."
        ]
    ]
}
