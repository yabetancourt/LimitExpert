import katex from "katex";
import AsciiMathParser from "asciimath2tex";

export class MathFormula extends HTMLElement {

    private _formula = '';

    constructor() {
        super();
    }

    connectedCallback() {
        katex.render(this.formula, this, {throwOnError: true});
    }

    get formula() {
        return this._formula;
    }

    set formula(value) {
        const parser: AsciiMathParser = new AsciiMathParser();
        this._formula = parser.parse(value);
        katex.render(this.formula, this, {throwOnError: true});
    }

}

customElements.define('math-formula', MathFormula);