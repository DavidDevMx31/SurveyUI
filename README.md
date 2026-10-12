# SurveyUI

SurveyUI is a SwiftUI package for presenting in-app surveys and collecting feedback. It provides single-choice, multiple-choice, and category-selection questions, a completion screen, and a callback with the collected answers.

> **Pre-release:** SurveyUI is currently pre-1.0. Its API and behavior may change between releases.

## Features

- Single-choice and multiple-choice questions.
- Category selection with a configurable maximum number of selections.
- An optional “Other” style option that lets respondents add a comment (one comment-enabled option per question).
- Optional survey skipping.
- A configurable completion title, description, optional image, and button label.
- A shared theme interface for colors and fonts (see [Customization](#customization)).

Open-ended questions are declared in the current model but their input UI is not implemented yet.

## Requirements

- iOS 15 or later.
- Swift 6.0 or later (the package declares Swift tools 6.0).
- Xcode 16 or later to use the Swift 6 toolchain.

## Installation

In Xcode, choose **File > Add Package Dependencies…** and enter:

```text
https://github.com/DavidDevMx31/SurveyUI.git
```

Or add the package to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/DavidDevMx31/SurveyUI.git", from: "0.1.0")
]
```

Then add `SurveyUI` to the target that uses it:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "SurveyUI", package: "SurveyUI")
    ]
)
```

The `0.1.0` version above is an example of a pre-1.0 semantic version. Use a version that has been published for the repository, or select the desired branch or version in Xcode.

## Quick start

Create the survey where you configure your feature, then present `SurveyView` from a SwiftUI view. This example uses the package's built-in completion content:

```swift
import SwiftUI
import SurveyUI

struct FeedbackScreen: View {
    @State private var survey: Survey?
    @State private var isPresentingSurvey = false

    var body: some View {
        Button("Give feedback") {
            isPresentingSurvey = true
        }
        .task {
            survey = try? makeSurvey()
        }
        .sheet(isPresented: $isPresentingSurvey) {
            if let survey {
                SurveyView(survey: survey) { result in
                    print("Survey: \(result.surveyId)")
                    for answer in result.answers {
                        print(answer.questionId, answer.selectedOptionsId ?? [], answer.comments ?? "")
                    }
                }
            }
        }
    }

    private func makeSurvey() throws -> Survey {
        let options = try [
            QuestionOption(id: "yes", description: "Yes"),
            QuestionOption(id: "no", description: "No")
        ]
        let question = try Question(
            id: "recommend",
            prompt: "Would you recommend us?",
            type: .singleChoice(options: options)
        )

        return try Survey(
            id: "product-feedback",
            markdownIntro: "**Thanks for sharing your feedback.**",
            questions: [question],
            completionContent: .example,
            skippable: true
        )
    }
}
```

## Configuration

The principal public models are:

- `QuestionOption(id:description:allowsText:)` defines a single or multiple choice option. Set `allowsText: true` on at most one option in a question to show a comment field when that option is selected.
- `CategoryOption(id:description:emoji:)` defines a category tile. Its emoji is optional.
- `QuestionType` supports `.singleChoice(options:)`, `.multipleChoice(options:)`, `.categorySelection(options:maxSelectableItems:)`, and `.open(placeholder:)`. The `.open` case currently renders no input UI.
- `Question(id:prompt:type:)` defines a question.
- `SurveyCompletionContent` defines the completion title, description, optional asset image name, and button title. The markdown initializer can be used to create formatted title and description text. `SurveyCompletionContent.example` provides the built-in default.
- `Survey` combines an ID, intro, questions, completion content, and an optional `skippable` flag. Its `markdownIntro` initializer supports inline Markdown formatting.

Initializers throw `SurveyDefinitionError` for empty required IDs or text, empty choice lists, duplicate option IDs within a question, more than one comment-enabled option, or a category maximum greater than the number of categories. Use unique, non-empty survey, question, and option IDs so results can be mapped reliably. Category questions also need a positive maximum; the current initializer does not reject zero or negative values.

Some model properties (including option labels, question prompts/types, survey intro/questions, and completion description/image/button fields) are currently internal. Supply these values through the public initializers; they cannot currently be read or changed directly by a package client.

## Results and callbacks

`SurveyView(survey:onCompleted:)` calls `onCompleted` with a `SurveyResult` when the respondent taps the completion button. `SurveyResult.surveyId` identifies the survey and `SurveyResult.answers` contains `QuestionResult` values. Each result exposes its `questionId`, optional `selectedOptionsId` array, and optional `comments` string. Single-choice answers contain one selected option ID; multiple-choice and category answers can contain several. Answers that have no selection or comment have `nil` fields.

The callback runs on completion, not when the respondent skips the survey.

## Customization

The survey definition supports inline Markdown in the intro and completion title/description, custom completion text, an optional completion image from an asset catalog, optional emoji on category options, and the `skippable` setting.

The UI reads colors and fonts from `SurveyUIThemeManager.shared`. Provide a type conforming to `SurveyUITheme` and assign an instance to the shared manager before presenting a survey. The protocol requires background and foreground colors, intro, question, callout, and body fonts, plus option background and selected/unselected foreground colors:

```swift
import SwiftUI
import SurveyUI

struct AppSurveyTheme: SurveyUITheme {
    var backgroundColor: Color? = Color("SurveyBackground")
    var foregroundColor: Color? = .primary

    var surveyIntroFont: Font = .title2
    var questionFont: Font = .title3
    var calloutFont: Font = .callout
    var bodyFont: Font = .body

    var optionBackgroundColor: Color = .blue
    var selectedOptionForegroundColor: Color = .white
    var unselectedOptionForegroundColor: Color = .blue
}

@MainActor
func configureSurveyTheme() {
    SurveyUIThemeManager.shared = AppSurveyTheme()
}
```

Set the theme during app or feature setup before showing `SurveyView`. The theme is shared globally by SurveyUI views. Fonts and colors can be chosen using your app's assets and design system.

Localization is not currently documented as supported. Some UI strings are hard-coded in the package, and localization support remains future work.

## Versioning and release status

SurveyUI is pre-1.0. Published releases are intended to follow semantic versioning; before 1.0, minor releases may include breaking API changes. Pin a version in production and review release notes when upgrading. The repository does not currently include a changelog.
