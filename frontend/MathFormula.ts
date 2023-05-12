import katex from "katex";

export class MathFormula extends HTMLElement {

    private _formula = '';

    constructor() {
        super();
    //     const shadow = this.attachShadow({mode: 'open'});
    //     const style = document.createElement('style');
    //     style.textContent = `
    //   .katex-html {
    //     display: block;
    //   }
    // `;
    //     if (style.sheet !== null)
    //         shadow.adoptedStyleSheets = [style.sheet];
    }

    connectedCallback() {
        katex.render(this.formula, this, {throwOnError: true});
    }

    get formula() {
        return this._formula;
    }

    set formula(value) {
        this._formula = value;
        katex.render(this.formula, this, {throwOnError: true});
    }

}

customElements.define('math-formula', MathFormula);