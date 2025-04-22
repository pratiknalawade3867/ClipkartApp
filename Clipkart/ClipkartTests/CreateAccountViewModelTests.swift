//
//  CreateAccountViewModelTests.swift
//  ClipkartTests
//
//  Created by pratik.nalawade on 13/03/25.
//

import XCTest
@testable import Clipkart

class CreateAccountViewModelTests: XCTestCase {

    var viewModel: CreateAccountViewModel!

    override func setUp() {
        super.setUp()
        viewModel = CreateAccountViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // Test: Validate fields when fields are empty
    func testFieldValidationWithEmptyFields() {
        // Given
        viewModel.email = ""
        viewModel.fullName = ""

        // When
        let isValid = viewModel.validateFields()

        // Then
        XCTAssertTrue(isValid)
        XCTAssertEqual(viewModel.emailError, "Email is required")
        XCTAssertEqual(viewModel.fullNameError, "Full Name is required")
    }

    // Test: Validate fields with non-empty fields
    func testFieldValidationWithNonEmptyFields() {
        // Given
        viewModel.email = "test@example.com"
        viewModel.fullName = "John Doe"

        // When
        let isValid = viewModel.validateFields()

        // Then
        XCTAssertTrue(isValid)
        XCTAssertNil(viewModel.emailError)
        XCTAssertNil(viewModel.fullNameError)
    }

    // Test: Toggle password visibility
    func testPasswordVisibilityToggle() {
        // Given
        let initialPasswordVisibility = viewModel.isPasswordVisible

        // When
        viewModel.isPasswordVisible.toggle()

        // Then
        XCTAssertNotEqual(viewModel.isPasswordVisible, initialPasswordVisibility)
    }
}
