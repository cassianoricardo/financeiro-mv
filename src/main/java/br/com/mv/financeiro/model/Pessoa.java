package br.com.mv.financeiro.model;

public class Pessoa {
	
	private String codPessoa;
	private String nome;
	private Long cpfCnpj;
	private Endereco endereco;
	private Long telefone;
	
	public String getCodPessoa() {
		return codPessoa;
	}
	public void setCodPessoa(String codPessoa) {
		this.codPessoa = codPessoa;
	}
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	public Long getCpfCnpj() {
		return cpfCnpj;
	}
	public void setCpfCnpj(Long cpfCnpj) {
		this.cpfCnpj = cpfCnpj;
	}
	public Endereco getEndereco() {
		return endereco;
	}
	public void setEndereco(Endereco codEndereco) {
		this.endereco = codEndereco;
	}
	public Long getTelefone() {
		return telefone;
	}
	public void setTelefone(Long telefone) {
		this.telefone = telefone;
	}
}
