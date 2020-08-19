package br.com.mv.financeiro.model;

public class Endereco {
	
	private Integer codEndereco;
	private String rua;
	private Integer numero;
	private String complemento;
	private String bairro;
	private String cidade;
	private String UF;
	private Integer CEP;
	
	public Integer getCodEndereco() {
		return codEndereco;
	}
	public void setCodEndereco(Integer codEndereco) {
		this.codEndereco = codEndereco;
	}
	public String getRua() {
		return rua;
	}
	public void setRua(String rua) {
		this.rua = rua;
	}
	public Integer getNumero() {
		return numero;
	}
	public void setNumero(Integer numero) {
		this.numero = numero;
	}
	public String getComplemento() {
		return complemento;
	}
	public void setComplemento(String complemento) {
		this.complemento = complemento;
	}
	public String getBairro() {
		return bairro;
	}
	public void setBairro(String bairro) {
		this.bairro = bairro;
	}
	public String getCidade() {
		return cidade;
	}
	public void setCidade(String cidade) {
		this.cidade = cidade;
	}
	public String getUF() {
		return UF;
	}
	public void setUF(String uF) {
		UF = uF;
	}
	public Integer getCEP() {
		return CEP;
	}
	public void setCEP(Integer cEP) {
		CEP = cEP;
	}

}
