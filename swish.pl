% Nome, linguagem, nivel, salario, idade, moradia, regime, anos de trabalho
candidato(ana, python, junior, 2000, 21, santos, clt, 2).
candidato(jose, python, junior, 3000, 23, praiagrande, pj, 1).
candidato(marcela, c, pleno, 4000, 28, santos, clt, 5).
candidato(rodrigo, java, senior, 4000, 32, saovicente, clt, 10).
candidato(luiz, cmaismais, pleno, 3500, 26, guaruja, clt, 8).
candidato(laura, java, senior, 7000, 30, praiagrande, clt, 6).

%Regras

help() :- writeln( "Seleção de candidatos" ),
    	  writeln( "Menu de ajuda" ),
    	  writeln( " 1 - Listagem de todos os candidatos cadastrados, usa-se candidatos. "),
    	  writeln( " 2 - Seleção de quais e quantos candidatos aptos, em relação a lingugem, usa-se
                     candidatoaptolinguagem(X)., onde X é uma linguagem" ),
          writeln( " 3 - Listagem das principais regiões dos candidatos, usa-se listamoradias."),
          writeln( " 4 - Seleção dos candidatos que estão na mesma região da empresa, usa-se regiao(X)., onde X
                     é uma cidade"),
          writeln( " 5 - Listagem da faixa salarial dos candidatos, usa-se faixasalarial."),
   	      writeln( " 6 - Seleção de candidatos referente a pretensão salarial, utiliza-se pretensaosalarial(X).,
                     onde X é um valor salarial "),
          writeln( " 7 - Listagem da faixa etária dos candidatos, usa-se faixaetaria."),
          writeln( " 7 - Listagem de candidatos proximos da aposentadoria (com parâmetro de 10 anos de serviço), 
                    usa-se aposentadoria."),
          writeln( " 8 - Seleção de candidatos com o regime solicitado, utiliza-se regime(X), onde X é um tipo de regime"),
		  writeln( " 9 - Seleção de candidatos em relação ao nível solicitado, utiliza-se nivel(X)., onde X é nível"),
    	  writeln( " 10 - Seleção de candidatos para a vaga, utiliza-se vaga(L,N,S,M,R)., onde L é uma linguagem, 
                    N é o nível, S é a pretensão salarial, M sendo moradia e R o regime do candidato").

candidatos() :- findall(NOME, candidato(NOME,LINGUAGEM,NIVEL,SALARIO,IDADE,MORADIA,REGIME,AT), R), length(R,TAM),
    			format("Quantidade de candidatos: ~d\n\n", [TAM]),
    			candidato(NOME,LINGUAGEM,NIVEL,SALARIO,IDADE,MORADIA,REGIME,AT),
    			format("Nome do candidato: ~s \nLinguagem: ~s \nNível: ~s \nSalário: ~d \nIdade: ~d \nMoradia: ~s \nRegime: ~s \nAnos de trabalho: ~d \n\n",
           		[NOME, LINGUAGEM, NIVEL, SALARIO, IDADE, MORADIA, REGIME,AT]), fail;true.

candidatoaptolinguagem(X) :- findall(X, candidato(_, X, _, _, _, _, _,_),R), length(R,TAM),
    						 format("Quantidade de candidatos aptos para ~s: ~d\n\n", [X,TAM]),
    						 candidato(NOME, X, NIVEL, _, _, _, _,_),
    						 format("Nome do candidato: ~s\nNivel: ~s\n\n", [NOME, NIVEL]), fail;true.

moradias(M) :- findall(X, candidato(_, _, _, _, _, X, _, _),R), sort(R, M).
listamoradias() :- moradias(M), format("Principais cidades: \n"), writeln(M).

regiao(X) :- findall(X, candidato(NOME, LINGUAGEM, NIVEL, _, _, X, _, _),R), length(R,TAM),
        	 format("Quantidade de candidatos morando em ~s: ~d\n\n", [X,TAM]),
    		 forall( (candidato(NOME, LINGUAGEM, NIVEL, _, _, MORADIA, _, _), MORADIA==X), 
             format("Nome do candidato: ~s \nLinguagem: ~s \nNível: ~s\n\n", [NOME, LINGUAGEM, NIVEL])).

faixasalarial() :- findall(X, candidato(_, _, _, X, _, _, _, _),R), min_member(MIN, R), max_member(MAX,R),
    			   format("Faixa salarial dos candidatos: R$~d - R$~d", [MIN,MAX]).

pretensaosalarial(X) :- findall(X, candidato(NOME, LINGUAGEM, NIVEL, X, _, _, _, _),R), length(R,TAM),
					    format("Quantidade de candidatos com pretensão salarial R$~d: ~d\n\n", [X,TAM]),
    				    forall( (candidato(NOME, LINGUAGEM, NIVEL, SALARIO, _, _, _, _), SALARIO==X), 
            		    format("Nome do candidato: ~s \nLinguagem: ~s \nNível: ~s\n\n", [NOME, LINGUAGEM, NIVEL])).
    
faixaetaria() :- findall(X, candidato(_, _, _, _, X, _, _, _),R), min_member(MIN, R), max_member(MAX,R),
    			 format("Faixa etária dos candidatos: ~d - ~d anos", [MIN,MAX]).

aposentadoria() :- forall( (candidato(NOME, _, _, _, _, _, _, AT), AP is 10-AT),
    			   format("Nome do candidato: ~s\nAnos para se aposentar: ~d\n\n", [NOME, AP])).

regime(X) :- findall(X, candidato(_, _, _, _, _, _, X, _),R), length(R,TAM),
    		 format("Quantidade de candidatos com regime ~s: ~d\n\n", [X,TAM]),
			 candidato(NOME, _, NIVEL, _, _, _, X, _),
    		 format("Nome do candidato: ~s\nNivel: ~s\n\n", [NOME, NIVEL]), fail;true.

nivel(X) :- findall(X, candidato(_, _, X, _, _, _, _, _),R), length(R,TAM),
    		format("Quantidade de candidatos no nível ~s: ~d\n\n", [X,TAM]),
			candidato(NOME, LINGUAGEM, X, _, _, _, _, _),
    		format("Nome do candidato: ~s\nlinguagem: ~s\n\n", [NOME, LINGUAGEM]), fail;true.

vaga(L,N,S,M,R) :- candidatoaptolinguagem(L), nivel(N), pretensaosalarial(S), regiao(M), regime(R).