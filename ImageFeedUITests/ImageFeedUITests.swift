import XCTest

final class ImageFeedUITests: XCTestCase {
    static let constants = ProfileConstants()
    private let app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 20))
        loginTextField.tap()
        loginTextField.typeText(ImageFeedUITests.constants.login)
        XCUIApplication().toolbars.buttons["Done"].tap()
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 7))
        passwordTextField.tap()
        passwordTextField.typeText(ImageFeedUITests.constants.password)
        webView.swipeUp()
        let webViewsQuery = app.webViews
        webViewsQuery.buttons["Login"].tap()
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 15))
    }

    func testFeed() throws {
        let tablesQuery = app.tables
               let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 0)
               let buttonLike = cellToLike.buttons["likeButton"]
               buttonLike.tap()
               sleep(2)
               XCTAssertTrue(cellToLike.buttons["LikeButtonOn"].exists)
               buttonLike.tap()
               sleep(2)
               XCTAssertTrue(cellToLike.buttons["LikeButtonOff"].exists)
               cellToLike.swipeUp()
               sleep(2)
               let cellToSingleImage = tablesQuery.children(matching: .cell).element(boundBy: 0)
               sleep(2)
               cellToSingleImage.tap()
               sleep(2)
               let image = app.scrollViews.images.element(boundBy: 0)
               image.pinch(withScale: 3, velocity: 1)
               image.pinch(withScale: 0.5, velocity: -1)
               let navBackButtonWhiteButton = app.buttons["backButton"]
               navBackButtonWhiteButton.tap()
               sleep(2)
               XCTAssertTrue(cellToSingleImage.exists)
    }

    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        XCTAssertTrue(app.staticTexts[ImageFeedUITests.constants.name].exists)
        XCTAssertTrue(app.staticTexts[ImageFeedUITests.constants.loginName].exists)
        app.buttons["logoutButton"].tap()
        sleep(1)
        app.alerts["exit"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(2)
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
}
