const APP_ORIGIN = "/";

describe("template spec", () => {
  beforeEach(() => {
    cy.visit(APP_ORIGIN);
  });

  it("counts", () => {
    cy.visit(APP_ORIGIN);

    const btn = cy.get('[data-cy="count"]');
    btn.should("have.text", "count is 0");
    btn.click();
    btn.should("have.text", "count is 1");
  });
});
