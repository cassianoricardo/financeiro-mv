package br.com.mv.financeiro.dao;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import br.com.mv.financeiro.model.Pessoa;

@Repository
public class PessoaDAO {
	
	public JdbcTemplate jdbcTemplate;
	
	@Autowired
	public PessoaDAO(DataSource dataSource) {
		jdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	public void inserirPessoa(Pessoa pessoa) {
		
		String codErro = new String();
		String mensagem = new String();;
	
		jdbcTemplate.update("call  pkg_pessoa.proc_cadastrar_pessoa(?,?,?,?,?,?,?,?,?,?,?,?)",
														pessoa.getNome(),
														pessoa.getCpfCnpj(),
														pessoa.getTelefone(),
														pessoa.getEndereco().getRua(),
														pessoa.getEndereco().getNumero(),
														pessoa.getEndereco().getComplemento(),
														pessoa.getEndereco().getBairro(),
														pessoa.getEndereco().getCidade(),
														pessoa.getEndereco().getUF(),
														pessoa.getEndereco().getCEP(),
														mensagem,
														codErro);
		System.out.println("mensagem: "+mensagem+" cod erro: "+codErro);
	}


}
