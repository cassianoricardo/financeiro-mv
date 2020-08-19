package br.com.mv.financeiro;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.jdbc.core.JdbcTemplate;

import br.com.mv.financeiro.config.AppConfig;
import br.com.mv.financeiro.dao.PessoaDAO;
import br.com.mv.financeiro.model.Endereco;
import br.com.mv.financeiro.model.Pessoa;


public class App {
	
	@Autowired
	static JdbcTemplate jdbcTemplate;
	 
	 private static final Logger log = LoggerFactory.getLogger(App.class);
	
		public static void main(String[] args) {
			AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
			
			PessoaDAO pessoaDAO = context.getBean(PessoaDAO.class);
			jdbcTemplate = pessoaDAO.jdbcTemplate;

			Pessoa pessoa = new Pessoa();
			
			pessoa.setNome("cassiano");
			pessoa.setCpfCnpj(88691094486L);
			pessoa.setTelefone(81979151939L);
			pessoa.setEndereco(new Endereco());
			pessoa.getEndereco().setRua("rua médico cesar cals de oliveira");
			pessoa.getEndereco().setBairro("pau amarelo");
			pessoa.getEndereco().setCidade("paulista");
			pessoa.getEndereco().setUF("PE");
			pessoa.getEndereco().setComplemento("casa");
			pessoa.getEndereco().setNumero(1805);
			pessoa.getEndereco().setCEP(530433760);
			
			pessoaDAO.inserirPessoa(pessoa);
			context.close();
}
}
