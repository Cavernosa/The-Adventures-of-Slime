programa
{
	inclua biblioteca Graficos --> g
	inclua biblioteca Teclado --> t
	inclua biblioteca Util --> u
	inclua biblioteca Texto --> tx
	inclua biblioteca Calendario --> c
	inclua biblioteca Mouse --> m
	inclua biblioteca Arquivos --> a
	inclua biblioteca Tipos --> tp
	inclua biblioteca Objetos --> o
	inclua biblioteca Matematica --> mt

	// Configura��es de jogo
	cadeia configuracoes_lingua = "Portugu�s (BR)"
	logico configuracoes_musica = falso,
	configuracoes_efeitos_sonoros = verdadeiro
	
	// Configura��es
	inteiro janela[] = {800, 600},
	lar = janela[0],
	alt = janela[1],
	janela_cor_fundo = 0x202030,
	janela_cor_fundo_interface = 0xB0C4DE,
	janela_cor_conteudo_interface = janela_cor_fundo,
	tela_atual = 0, // 0 = menu, 1 = config., 2 = sel. de personagem, 3 = jogo
	pontuacao = 0,
	contador_tempo_inicio = 0,
	contador_tempo_minutos = 0,
	fps_tempo_inicio = 0,
	fps_taxa = 0,
	fps_atual = 0,
	selecao_de_personagem_posicao_y_retangulo = 80,
	selecao_de_personagem_divisao_entre_retangulo = 50, 
	selecao_de_personagem_largura_ratangulo = 200
	
	cadeia nome_personagem[3] = {
		"Slimey",
		"Goop",
		"Slurry"
	},
	pasta_jogo = u.obter_diretorio_usuario() + "/game",
	pasta_sprites = pasta_jogo + "/sprites",
	pasta_fonts = pasta_jogo + "/fonts",
	pasta_pontos = pasta_jogo + "/points",
	pasta_menus = pasta_jogo + "/menus",
	pasta_config = pasta_jogo + "/config",
	pasta_lang = pasta_jogo + "/lang"
	
	logico contador_tempo_obter_tempo = verdadeiro,
	fps_obter_tempo = verdadeiro,
	exibir_tutorial = falso,
	executando = verdadeiro,
	erro_carregamento_arquivos = falso
	
	// Arquivos
	inteiro arq_config = 0,
	arq_pontuacao = 0,
	obj_pontuacao = 0,
	pt_br = 0,
	en_us = 0
	
	inteiro lang_pt_br = 0,
	lang_en_us = 0

	// Imagens
	inteiro menu_play_button = 0,
	menu_config_button = 0,
	menu_quit_button = 0,
	sprite_fantasma_cinza = 0

	// Jogador
	cadeia jogador_cor = "verde"
	inteiro jogador_velocidade,
	jogador_sprite = g.carregar_imagem(pasta_sprites + "/slime_" + jogador_cor + ".png"),
	jogador_tamanho[2] = {
		g.largura_imagem(jogador_sprite) / 2,
		g.altura_imagem(jogador_sprite)
	},
	jogador_posicao[2] = {
		(lar / 2) - (jogador_tamanho[0] / 2),
		(alt / 2) - (jogador_tamanho[1] / 2)
	}
	logico jogador_virado_para_a_direita = verdadeiro

	// Ponto
	cadeia ponto_cor = "vermelho"
	inteiro maior_pontuacao = 0,
	ponto_sprite = g.carregar_imagem(pasta_pontos + "/ponto_" + ponto_cor + ".png"),
	ponto_tamanho = g.altura_imagem(ponto_sprite),
	ponto_posicao[2]
	logico sortear_nova_posicao_ponto = verdadeiro

	// Inimigos
	const inteiro numero_de_inimigos = 2
	inteiro posicao_inimigos = o.criar_objeto(),
	posicao_inimigo[numero_de_inimigos][2]
	inteiro tipo_inimigos = o.criar_objeto_via_json("{\"inimigo_1\": \"fantasma_cinza\"}")
	
	funcao inicio()
	{
		// Inicia o modo gr�fico e define as dimens�es da janela
		g.iniciar_modo_grafico(falso)
		g.definir_dimensoes_janela(janela[0], janela[1])
		g.definir_icone_janela(g.carregar_imagem(pasta_config + "/icon.png"))

		// Carrega os arquivos
		carregar_fontes()
		carregar_imagens()
		carregar_arquivos()

		definir_posicao_inimigo(1, "fantasma_cinza")
		
		// Loop respons�vel por fazer o programa funcionar
		enquanto(executando){
			// Detecta se o jogador apertou SHIFT + ESC, para finalizar o loop
			se(t.tecla_pressionada(t.TECLA_ESC) e t.tecla_pressionada(t.TECLA_SHIFT)){
				finalizar()
				pare
			}
			
			// Obtem o fps
			obter_fps()
			
			// Define a cor de fundo da janela
			g.definir_cor(janela_cor_fundo)
			g.limpar()
			
			// Esta � a tela de menu
			se(tela_atual == 0){
				menu()
			}
			
			// Esta � a tela de configura��es
			senao se(tela_atual == 1){
				configuracoes()
			}
			
			// Esta � a tela de sela��o de personagem
			senao se(tela_atual == 2){
				selecao_de_personagem()
			}
			
			// Esta � a tela de jogo
			senao se(tela_atual == 3){
				jogo()
			}

			// Detecta se o jogador apertou uma determinada tecla que tenha uma fun��o espec�fica
			funcoes_teclado()
			
			// Renderiza os desenhos; 
			// [!] O "se(executando)" serve para n�o ocorrer um erro, quando o jogador apertar SHIFT + ESC
			se(executando){
				g.renderizar()
			}
		}
	}
	funcao finalizar(){
		liberar_imagens()
		g.minimizar_janela()
		u.aguarde(100)
		g.encerrar_modo_grafico()
		executando = falso
	}
	funcao desenhar_jogador(){		
		// Desenha o jogador
		se(jogador_virado_para_a_direita){
			g.desenhar_porcao_imagem(jogador_posicao[0], jogador_posicao[1],
			0, 0, jogador_tamanho[0], jogador_tamanho[1], jogador_sprite)
		}
		senao{
			g.desenhar_porcao_imagem(jogador_posicao[0], jogador_posicao[1],
			jogador_tamanho[0], 0, jogador_tamanho[0], jogador_tamanho[1], jogador_sprite)
		}
	}
	funcao desenhar_ponto(){
		// Desenha o ponto
		g.desenhar_imagem(ponto_posicao[0], ponto_posicao[1], ponto_sprite)
	}
	funcao desenhar_inimigo(inteiro numero_do_inimigo){
		desenhar_sprite_inimigo(o.obter_propriedade_tipo_cadeia(tipo_inimigos, "inimigo_" + numero_do_inimigo), numero_do_inimigo, verdadeiro)
	}
	funcao desenhar_sprite_inimigo(cadeia tipo_do_inimigo, inteiro numero_do_inimigo, logico inimigo_virado_para_a_direita){
		se(tipo_do_inimigo == "fantasma_cinza" e inimigo_virado_para_a_direita){
			g.desenhar_porcao_imagem(json_inimigo_posicao(numero_do_inimigo, "x"),
			json_inimigo_posicao(numero_do_inimigo, "y"), 0, 0,
			g.largura_imagem(sprite_fantasma_cinza) / 2, g.altura_imagem(sprite_fantasma_cinza), sprite_fantasma_cinza)
		}
		senao se(tipo_do_inimigo == "fantasma_cinza" e nao inimigo_virado_para_a_direita){
			g.desenhar_porcao_imagem(json_inimigo_posicao(numero_do_inimigo, "x"),
			json_inimigo_posicao(numero_do_inimigo, "y"), g.largura_imagem(sprite_fantasma_cinza) / 2, 0,
			g.largura_imagem(sprite_fantasma_cinza) / 2, g.altura_imagem(sprite_fantasma_cinza), sprite_fantasma_cinza)
		}
	}
	funcao definir_posicao_inimigo(inteiro numero_do_inimigo, cadeia tipo_do_inimigo){
		se(tipo_do_inimigo == "fantasma_cinza"){
			o.atribuir_propriedade(posicao_inimigos, "inimigo_" + numero_do_inimigo + "_x", lar / 2 - (g.largura_imagem(sprite_fantasma_cinza) / 2) / 2)
			o.atribuir_propriedade(posicao_inimigos, "inimigo_" + numero_do_inimigo + "_y", alt / 2 - g.altura_imagem(sprite_fantasma_cinza) / 2)
		}
	}
	funcao inteiro json_inimigo_posicao(inteiro numero_do_inimigo, cadeia x_y){
		retorne o.obter_propriedade_tipo_inteiro(posicao_inimigos, "inimigo_" + numero_do_inimigo + "_" + x_y)
	}
	funcao movimento_inimigo(inteiro numero_do_inimigo){
		inteiro num[2] = {
			json_inimigo_posicao(numero_do_inimigo, "x"),
			json_inimigo_posicao(numero_do_inimigo, "y")
		}

		se(jogador_posicao[0] > num[0]){
			o.atribuir_propriedade(posicao_inimigos, "inimigo_" + numero_do_inimigo + "_x", num[0] + 1)
		}
		se(jogador_posicao[0] < num[0]){
			o.atribuir_propriedade(posicao_inimigos, "inimigo_" + numero_do_inimigo + "_x", num[0] - 1)
		}
		se(jogador_posicao[1] > num[1]){
			o.atribuir_propriedade(posicao_inimigos, "inimigo_" + numero_do_inimigo + "_y", num[1] + 1)
		}
		se(jogador_posicao[1] < num[1]){
			o.atribuir_propriedade(posicao_inimigos, "inimigo_" + numero_do_inimigo + "_y", num[1] - 1)
		}
	}
	funcao menu(){
		// Define a cor do texto dos bot�es
		g.definir_cor(janela_cor_fundo_interface)
		
		// Desenha o bot�o de jogar
		g.desenhar_imagem(lar / 2 - 75, alt / 2, menu_play_button)
		cadeia texto_play = json("menu_jogar")
		g.desenhar_texto((lar / 2) - (g.altura_texto("A") * tx.numero_caracteres(texto_play)) / 2,
		lar / 2 - 82 + g.altura_imagem(menu_play_button), texto_play)

		// Desenha o bot�o de configura��es
		g.desenhar_imagem(lar / 4 - 75, alt / 2 + 45, menu_config_button)
		cadeia texto_config = json("menu_configuracoes")
		g.desenhar_texto((lar / 4 - 32) - (g.altura_texto("A") * tx.numero_caracteres(texto_config)) / 2,
		lar / 2 - 38 + g.altura_imagem(menu_config_button), texto_config)

		// Desenha o bot�o de sair
		g.desenhar_imagem(lar / 2 + lar / 4 - 32, alt / 2 + 45, menu_quit_button)
		cadeia texto_quit = json("menu_sair")
		g.desenhar_texto((lar / 2 + lar / 4 + 15) - (g.altura_texto("A") * tx.numero_caracteres(texto_quit)) / 2,
		lar / 2 - 38 + g.altura_imagem(menu_quit_button), texto_quit)

		// Detecta se o jogador selecionou um bot�o do menu
		detectar_se_jogador_selecionou_botao_menu()
	}
	funcao selecao_de_personagem(){
		inteiro slime_verde = g.carregar_imagem(pasta_jogo + "/menus/slimes/slime_verde.png"),
		slime_azul = g.carregar_imagem(pasta_jogo + "/menus/slimes/slime_azul.png"),
		slime_laranja = g.carregar_imagem(pasta_jogo + "/menus/slimes/slime_laranja.png")

		// Escreve "Sele��o de personagem"
		g.definir_cor(0xffffff)
		g.definir_tamanho_texto(25.0)
		centralizar_texto(25, json("selpersonagem_selecao_de_personagem"))

		// Desenha as divis�es de cada personagem
		para(inteiro q = 1; q - 1 < 3; q++){
			g.definir_cor(janela_cor_fundo_interface)
			g.desenhar_retangulo((q * selecao_de_personagem_divisao_entre_retangulo) + ((q - 1) * selecao_de_personagem_largura_ratangulo),
			selecao_de_personagem_posicao_y_retangulo, selecao_de_personagem_largura_ratangulo, alt - (selecao_de_personagem_posicao_y_retangulo * 2) + 25, falso, verdadeiro)
			g.definir_cor(janela_cor_fundo)
			g.desenhar_retangulo((q * selecao_de_personagem_divisao_entre_retangulo) + ((q - 1) * selecao_de_personagem_largura_ratangulo) + 10,
			selecao_de_personagem_posicao_y_retangulo + 10, selecao_de_personagem_largura_ratangulo - 20, 180, falso, verdadeiro)
		}

		// Desenha a imagem de cada personagem
		g.desenhar_imagem(selecao_de_personagem_divisao_entre_retangulo + 10, selecao_de_personagem_posicao_y_retangulo + 25, slime_verde)
		g.desenhar_imagem((selecao_de_personagem_divisao_entre_retangulo * 2 + selecao_de_personagem_largura_ratangulo) + 10, selecao_de_personagem_posicao_y_retangulo + 25, slime_azul)
		g.desenhar_imagem((selecao_de_personagem_divisao_entre_retangulo * 3 + selecao_de_personagem_largura_ratangulo * 2) + 10, selecao_de_personagem_posicao_y_retangulo + 25, slime_laranja)

		// Escreve o nome dos personagens
		para(inteiro q = 1; q - 1 < 3; q++){
			// Vari�vel que vai auxiliar na hora de desenhar o texto
			inteiro x = (q * selecao_de_personagem_divisao_entre_retangulo) + ((q - 1) * selecao_de_personagem_largura_ratangulo) + 10

			// Define o tamanho e a cor do texto
			g.definir_tamanho_texto(18.0)
			g.definir_cor(janela_cor_fundo)

			// Desenha o texto centralizado do nome do personagem(faz a m�dia do tamanho do quadrado e centraliz o texto apartir deste valor)
			g.desenhar_texto((x + (x + selecao_de_personagem_largura_ratangulo - 20)) / 2 - (g.altura_texto("A") * tx.numero_caracteres(nome_personagem[q - 1])) / 2,
			selecao_de_personagem_posicao_y_retangulo + 10 + 190, nome_personagem[q - 1])
		}
		
		// Detecta se o jogador selecionou um personagem
		detectar_se_jogador_selecionou_personagem()
		
		// Libera as imagens, para n�o ocorrer um estouro de mem�ria
		g.liberar_imagem(slime_verde)
		g.liberar_imagem(slime_azul)
		g.liberar_imagem(slime_laranja)
	}
	funcao detectar_se_jogador_selecionou_botao_menu(){
		inteiro x = m.posicao_x(), y = m.posicao_y()
		se(m.botao_pressionado(m.BOTAO_ESQUERDO)){
			// Clique no bot�o de jogar
			se(x > lar / 2 - 75 e x < lar / 2 - 75 + g.largura_imagem(menu_play_button) e
			y > alt / 2 e y < alt / 2 + g.altura_imagem(menu_play_button)){
				tela_atual = 2
			}

			// Clique no bot�o de configura��es
			se(x > lar / 4 - 75 e x < lar / 4 - 75 + g.largura_imagem(menu_config_button) e
			y > alt / 2 + 45 e y < alt / 2 + 45 + g.altura_imagem(menu_config_button)){
				tela_atual = 1
			}

			// Clique no bot�o de sair
			se(x > lar / 2 + lar / 4 - 32 e x < lar / 2 + lar / 4 - 32 + g.largura_imagem(menu_quit_button) e
			y > alt / 2 + 45 e y < alt / 2 + 45 + g.altura_imagem(menu_quit_button)){
				finalizar()
			}
		}
		
		// Loop que evita eventuais cliques excessivos do jogador
		enquanto(m.algum_botao_pressionado()){}
	}
	funcao detectar_se_jogador_selecionou_personagem(){
		inteiro x = m.posicao_x(), y = m.posicao_y()

		// Detecta se o jogador selecionou um personagem
		se(m.botao_pressionado(m.BOTAO_ESQUERDO)){
			se(y >= selecao_de_personagem_posicao_y_retangulo e y <= alt - (selecao_de_personagem_divisao_entre_retangulo + 8)){
				se(x >= selecao_de_personagem_divisao_entre_retangulo e x <= selecao_de_personagem_divisao_entre_retangulo + selecao_de_personagem_largura_ratangulo){
					jogador_cor = "verde"
					jogador_sprite = g.carregar_imagem(pasta_sprites + "/slime_" + jogador_cor + ".png")
					tela_atual = 3
				}
				se(x >= selecao_de_personagem_divisao_entre_retangulo * 2 + selecao_de_personagem_largura_ratangulo e x <= selecao_de_personagem_divisao_entre_retangulo * 2 + selecao_de_personagem_largura_ratangulo * 2){
					jogador_cor = "azul"
					jogador_sprite = g.carregar_imagem(pasta_sprites + "/slime_" + jogador_cor + ".png")
					tela_atual = 3
				}
				se(x >= selecao_de_personagem_divisao_entre_retangulo * 3 + selecao_de_personagem_largura_ratangulo * 2 e x <= selecao_de_personagem_divisao_entre_retangulo * 3 + selecao_de_personagem_largura_ratangulo * 3){
					jogador_cor = "laranja"
					jogador_sprite = g.carregar_imagem(pasta_sprites + "/slime_" + jogador_cor + ".png")
					tela_atual = 3
				}
			}
		}

		// Loop que evita eventuais cliques excessivos do jogador
		enquanto(m.algum_botao_pressionado()){}
	}
	funcao jogo(){		
		// Sorteia uma nova posi��o do ponto, caso necess�rio
		se(sortear_nova_posicao_ponto){
			sortear_nova_posicao_ponto = falso
			sortear_posicao_ponto()
		}
			
		// Fun��es referentes a eventos
		detectar_se_jogador_pegou_ponto()
			
		// Fun��es referentes a movimenta��o
		movimento_jogador()
		movimento_inimigo(1)
		detectar_colisao_com_a_janela()
		
		// Fun��es referentes a desenhos
		desenhar_ponto()
		desenhar_inimigo(1)
		desenhar_jogador()
		desenhar_interface()
		
		// Inicia o tutorial, caso ainda n�o tenha sido iniciado
		se(exibir_tutorial){
			tutorial()
		}
	}
	funcao configuracoes(){
		g.definir_cor(janela_cor_fundo_interface)
		g.definir_tamanho_texto(20.0)
		centralizar_texto((alt / 4) / 4, json("menu_configuracoes"))

		// Desenha o bot�o de voltar
		g.definir_cor(janela_cor_fundo_interface)
		g.desenhar_retangulo(lar - 60, 10, 50, 27, falso, verdadeiro)
		g.definir_cor(janela_cor_conteudo_interface)
		g.definir_tamanho_texto(25.0)
		g.desenhar_texto(lar - 45, 12, ">")

		// Desenha os textos de configura��o
		g.definir_cor(janela_cor_fundo_interface)
		g.definir_tamanho_texto(12.0)
		inteiro x = 25

		// L�ngua
		g.desenhar_texto(x, alt / 4, "L�ngua / language")
		g.desenhar_texto((lar - x) - (tx.numero_caracteres(configuracoes_lingua) * g.altura_texto("A")),
		alt / 4, configuracoes_lingua)

		// M�sica
		g.desenhar_texto(x, alt / 4 + g.altura_texto("A") * 2, o.obter_propriedade_tipo_cadeia(lingua_escolhida(), "config_musica"))
		se(configuracoes_musica == falso){
			g.desenhar_texto((lar - x) - (tx.numero_caracteres(json("nao")) * g.altura_texto("A")),
			alt / 4 + g.altura_texto("A") * 2, json("nao"))
		}
		senao{
			g.desenhar_texto((lar - x) - (tx.numero_caracteres(json("sim")) * g.altura_texto("A")),
			alt / 4 + g.altura_texto("A") * 2, json("sim"))
		}

		// Efeitos sonoros
		g.desenhar_texto(x, alt / 4 + g.altura_texto("A") * 4, o.obter_propriedade_tipo_cadeia(lingua_escolhida(), "config_efeitos_sonoros"))
		se(configuracoes_efeitos_sonoros == falso){
			g.desenhar_texto((lar - x) - (tx.numero_caracteres(json("nao")) * g.altura_texto("A")),
			alt / 4 + g.altura_texto("A") * 4, json("nao"))
		}
		senao{
			g.desenhar_texto((lar - x) - (tx.numero_caracteres(json("sim")) * g.altura_texto("A")),
			alt / 4 + g.altura_texto("A") * 4, json("sim"))
		}

		escolha(detectar_se_jogador_selecionou_botao_configuracoes()){
			// Bot�o de voltar ao menu
			caso 0:
				tela_atual = 0
				pare
			
			// Bot�o de escolha de idioma
			caso 1:
				se(configuracoes_lingua == "Portugu�s (BR)"){
					configuracoes_lingua = "English (US)"
				}
				senao{
					configuracoes_lingua = "Portugu�s (BR)"
				}
				pare

			// Bot�o de m�sica
			caso 2:
				configuracoes_musica = nao configuracoes_musica
				pare

			// Bot�o de efeitos sonoros
			caso 3:
				configuracoes_efeitos_sonoros = nao configuracoes_efeitos_sonoros
				pare
		}
	}
	funcao inteiro detectar_se_jogador_selecionou_botao_configuracoes(){
		inteiro x = m.posicao_x(), y = m.posicao_y()
		inteiro botao_pressionado = -1

		se(m.botao_pressionado(m.BOTAO_ESQUERDO)){
			// Bot�o de voltar ao menu
			se(x > lar - 60 e x < lar - 60 + 50 e y > 10 e y < 10 + 27){
				botao_pressionado = 0
			}

			// Bot�o de escolha de idioma
			se(y > alt / 4 e y < alt / 4 + g.altura_texto("A")){
				botao_pressionado = 1
			}
			
			// Bot�o de m�sica
			se(y > alt / 4 + g.altura_texto("A") * 2 e y < alt / 4 + g.altura_texto("A") * 3){
				botao_pressionado = 2
			}
			
			// Bot�o de efeitos sonoros
			se(y > alt / 4 + g.altura_texto("A") * 4 e y < alt / 4 + g.altura_texto("A") * 5){
				botao_pressionado = 3
			}

			// Loop que evita excessiovos cliques do jogador no mesmo bot�o
			enquanto(m.algum_botao_pressionado()){}
		}
		
		// Retorna um n�mero equivalente a um bot�o da tela de configura��es
		retorne botao_pressionado
	}
	funcao erro_arquivos(){
		erro_carregamento_arquivos = verdadeiro

		// Define a cor de fundo
		g.definir_cor(janela_cor_fundo)
		g.limpar()
		
		// Escreve os textos informativos
		g.definir_cor(janela_cor_fundo_interface)
		centralizar_texto(alt / 4, "[!] FALHA NO CARREGAMENTO DOS ARQUIVOS DO JOGO [!]")
		centralizar_texto(alt / 2 - g.altura_texto("A") / 2, "Parece que h� alguns arquivos faltando na pasta do jogo.")
		centralizar_texto(alt / 2 - g.altura_texto("A") / 2 + g.altura_texto("A") * 4, "1. Verifique se n�o mudou o diret�rio de alguma pasta ou arquivo;")
		centralizar_texto(alt / 2 - g.altura_texto("A") / 2 + g.altura_texto("A") * 6, "2. Verifique se n�o est� faltando nenhuma pasta ou arquivo;")
		centralizar_texto(alt / 2 - g.altura_texto("A") / 2 + g.altura_texto("A") * 8, "3. Reinicie o jogo, pode ser que tenha ocorrido um bug.")
		centralizar_texto(alt / 2 - g.altura_texto("A") / 2 + g.altura_texto("A") * 12, "Pressione SHIFT + ESC para finalizar e verificar os arquivos.")
		centralizar_texto(alt / 2 - g.altura_texto("A") / 2 + g.altura_texto("A") * 14, "Pasta do jogo: " + pasta_jogo)
		g.renderizar()
		
		// Loop que aguarda o jogador finalizar o programa
		enquanto(nao(t.tecla_pressionada(t.TECLA_ESC) e t.tecla_pressionada(t.TECLA_SHIFT))){}
		finalizar()
		executando = falso
	}
	funcao sortear_posicao_ponto(){
		// Sorteia uma nova possi��o para o ponto
		inteiro sorteio_x = sorteia(0, lar - ponto_tamanho), sorteio_y = sorteia(25, alt - ponto_tamanho)
		ponto_posicao[0] = sorteio_x
		ponto_posicao[1] = sorteio_y
	}
	funcao movimento_jogador(){
		se(lar <= 750){
			jogador_velocidade = 1
		}
		senao{
			jogador_velocidade = 2
		}
		// Detecta se o jogador pressionou uma tecla
		se(t.tecla_pressionada(t.TECLA_W) ou t.tecla_pressionada(t.TECLA_SETA_ACIMA)){
			jogador_posicao[1] -= jogador_velocidade
		}
		se(t.tecla_pressionada(t.TECLA_A)  ou t.tecla_pressionada(t.TECLA_SETA_ESQUERDA)){
			jogador_posicao[0] -= jogador_velocidade
			jogador_virado_para_a_direita = falso
		}
		se(t.tecla_pressionada(t.TECLA_S) ou t.tecla_pressionada(t.TECLA_SETA_ABAIXO)){
			jogador_posicao[1] += jogador_velocidade
		}
		se(t.tecla_pressionada(t.TECLA_D) ou t.tecla_pressionada(t.TECLA_SETA_DIREITA)){
			jogador_posicao[0] += jogador_velocidade
			jogador_virado_para_a_direita = verdadeiro
		}
	}
	funcao funcoes_teclado(){
		// Salva uma captura de tela na pasta do jogo
		se(t.tecla_pressionada(t.TECLA_F2)){
			inteiro tela = g.renderizar_imagem(lar, alt)
			g.salvar_imagem(tela, pasta_jogo + "/capturas de tela/captura" + c.hora_atual(falso) +
			c.minuto_atual() + c.segundo_atual() + c.milisegundo_atual() + c.dia_mes_atual()
			+ c.mes_atual() + c.ano_atual() + ".png")

			// Loop que evita excessivos cliques do jogador na mesma tecla, sem alterar o movimento do personagem
			enquanto(t.alguma_tecla_pressionada()){}
		}

		// Reseta o jogo atual e vai para a sele��o de personagens
		se(tela_atual == 3 e t.tecla_pressionada(t.TECLA_R)){
			pontuacao = 0
			jogador_posicao[0] = (lar / 2) - (jogador_tamanho[0] / 2)
			jogador_posicao[1] = (alt / 2) - (jogador_tamanho[1] / 2)
			jogador_virado_para_a_direita = verdadeiro
			sortear_nova_posicao_ponto = verdadeiro
			contador_tempo_obter_tempo = verdadeiro
			contador_tempo_minutos = 0
			tela_atual = 2

			// Loop que evita excessivos cliques do jogador na mesma tecla, sem alterar o movimento do personagem
			enquanto(t.alguma_tecla_pressionada()){}
		}
		
		// Pausa o jogo
		se(tela_atual == 3 e t.tecla_pressionada(t.TECLA_P)){
			g.definir_opacidade(100)
			g.definir_cor(0x404040)
			g.desenhar_retangulo(0, 0, lar, alt, falso, verdadeiro)
			g.renderizar()
			g.definir_opacidade(255)
			
			// Loop que evita excessivos cliques do jogador na mesma tecla, sem alterar o movimento do personagem
			enquanto(t.alguma_tecla_pressionada()){}
			
			// Loop que aguarda o jogador apertar novamente a tecla P
			enquanto(nao t.tecla_pressionada(t.TECLA_P)){}
			
			// Loop que evita excessivos cliques do jogador na mesma tecla, sem alterar o movimento do personagem
			enquanto(t.alguma_tecla_pressionada()){}
		}
	}
	funcao detectar_colisao_com_a_janela(){
		// Detecta se o jogador saiu para fora da janela e o coloca novamente na janela
		se(jogador_posicao[1] < 25){
			jogador_posicao[1] += jogador_velocidade
		}
		se(jogador_posicao[1] > alt - jogador_tamanho[1]){
			jogador_posicao[1] -= jogador_velocidade
		}
		se(jogador_posicao[0] < 0){
			jogador_posicao[0] += jogador_velocidade
		}
		se(jogador_posicao[0] > lar - jogador_tamanho[0]){
			jogador_posicao[0] -= jogador_velocidade
		}
	}
	funcao detectar_se_jogador_pegou_ponto(){
		// Vari�veis que ser�o usadas para detectar se o jogador est� realmente em cima do ponto
		logico x = falso, y = falso
		
		// Detecta se o jogador est� em cima do ponto
		para(inteiro c = ponto_posicao[0]; c < ponto_posicao[0] + ponto_tamanho; c++){
			para(inteiro d = jogador_posicao[0]; d < jogador_posicao[0] + jogador_tamanho[0]; d++){
				se(d == c){
					x = verdadeiro
				}
			}
		}
		para(inteiro c = ponto_posicao[1]; c < ponto_posicao[1] + ponto_tamanho; c++){
			para(inteiro d = jogador_posicao[1]; d < jogador_posicao[1] + jogador_tamanho[1]; d++){
				se(d == c){
					y = verdadeiro
				}
			}
		}
		
		// Caso o jogador esteja em cima do ponto, a pontua��o aumenta e uma nova posi��o do ponto � sorteada
		se(x e y){
			pontuacao++
			
			// Reseta a pontua��o do jogador quando ele atinge um valor maior que 999 pontos
			se(pontuacao > 999){
				pontuacao = 0
			}
			
		   	sortear_nova_posicao_ponto = verdadeiro
		}
	}
	funcao desenhar_interface(){
		// Desenha o ret�ngulo de fundo
		g.definir_cor(janela_cor_fundo_interface)
		g.desenhar_retangulo(0, 0, lar, 25, falso, verdadeiro)

		// Define a cor do conte�do a ser desenhado na interface
		g.definir_cor(janela_cor_conteudo_interface)

		// Desenhos da interface
		interface_desenhar_pontuacao()
		centralizar_texto(7, contador_tempo_minutos + ":" + interface_obter_tempo())
		interface_desenhar_fps()
	}
	funcao cadeia interface_obter_tempo(){		
		// Obtem um tempo para servir de base na primeira vez que a fun��o � executada
		se(contador_tempo_obter_tempo){
			contador_tempo_inicio = u.tempo_decorrido()
			contador_tempo_obter_tempo = falso
		}

		// Detecta se passou 1 minuto
		inteiro contador_tempo = (u.tempo_decorrido() - contador_tempo_inicio) / 1000
		se(contador_tempo >= 60){
			contador_tempo_minutos++
			contador_tempo_obter_tempo = verdadeiro
		}

		// Coloca 0(zero(s)) na frente dos segundos
		cadeia contador_tempo_cadeia = contador_tempo + ""
		se(contador_tempo < 10){
			contador_tempo_cadeia = "0" + contador_tempo
		}
		
		// Retorna o tempo, em uma cadeia
		retorne contador_tempo_cadeia
	}
	funcao interface_desenhar_pontuacao(){
		cadeia pontos = pontuacao + "", maior_pontos = maior_pontuacao + ""
		
		// Coloca 0(zero(s)) na frente das pontua��es, caso as pontua��es forem menores que 100 e/ou 10
		se(pontuacao < 100 e pontuacao < 10){
			pontos = "00" + pontos
		}
		senao se(pontuacao < 100 e pontuacao >= 10){
			pontos = "0" + pontos
		}
		se(maior_pontuacao < 100 e maior_pontuacao < 10){
			maior_pontos = "00" + maior_pontos
		}
		senao se(maior_pontuacao < 100 e maior_pontuacao >= 10){
			maior_pontos = "0" + maior_pontos
		}
		
		// Desenha a pontua��o e a maior pontua��o do jogador
		g.definir_tamanho_texto(14.0)
		se(pontuacao < maior_pontuacao){
			g.desenhar_texto(10, 7, pontos + " | " + maior_pontos)
		}
		senao se(pontuacao >= maior_pontuacao){
			g.desenhar_texto(10, 7, pontos)
		}

		// Atualiza a maior pontua��o, caso necessario
		interface_atualizar_maior_pontuacao()
	}
	funcao interface_desenhar_fps(){
		cadeia fps = fps_atual + ""

		// P�e zeros(0) na frente do fps, caso ele for menor que 100 e/ou 10
		se(fps_atual < 10){
			fps = "00" + fps
		}
		senao se(fps_atual < 100){
			fps = "0" + fps
		}
		
		// Desenha o fps atual
		g.definir_tamanho_texto(14.0)
		g.desenhar_texto(lar - 10 - (g.altura_texto("A") * tx.numero_caracteres("FPS: " + fps)),
		7, "FPS: " + fps)
	}
	funcao carregar_imagens(){
		menu_play_button = g.carregar_imagem(pasta_menus + "/buttons/play_button.png")
		menu_config_button = g.carregar_imagem(pasta_menus + "/buttons/config_button.png")
		menu_quit_button = g.carregar_imagem(pasta_menus + "/buttons/quit_button.png")
		sprite_fantasma_cinza = g.carregar_imagem(pasta_sprites + "/fantasma_cinza.png")
	}
	funcao liberar_imagens(){
		g.liberar_imagem(menu_play_button)
		g.liberar_imagem(menu_config_button)
		g.liberar_imagem(menu_quit_button)
	}
	funcao carregar_fontes(){
		// Carrega as fontes
		g.carregar_fonte(pasta_fonts + "/PressStart2P.ttf")
		g.definir_fonte_texto("Press Start 2P")
	}
	funcao carregar_arquivos(){
		// Carrega o arquivo de configura��es
		se(a.arquivo_existe(pasta_config + "/config.config")){
			arq_config = a.abrir_arquivo(pasta_config + "/config.config", a.MODO_LEITURA)

			// L� se o tutorial j� foi exibido
			cadeia linha = a.ler_linha(arq_config)
			se(linha == "tutorial_exibido: false;"){
				exibir_tutorial = verdadeiro
			}
		}
		senao{
			erro_arquivos()
		}

		// Carrega o arquivo de pontua��es
		se(a.arquivo_existe(pasta_config + "/pontuacao.config")){
			// L� o arquivo de pontua��o e passa o c�digo json para uma vari�vel
			arq_pontuacao = a.abrir_arquivo(pasta_config + "/pontuacao.config", a.MODO_LEITURA)
			cadeia json_pontuacao = ""
			enquanto(nao a.fim_arquivo(arq_pontuacao)){
				json_pontuacao += a.ler_linha(arq_pontuacao)
			}
			obj_pontuacao = o.criar_objeto_via_json("{" + json_pontuacao + "}")
			maior_pontuacao = tp.cadeia_para_inteiro(o.obter_propriedade_tipo_cadeia(obj_pontuacao, "maior_pontuacao"), 10)
		}
		senao{
			erro_arquivos()
		}

		// Carrega os arquivos referentes a linguagens
		se(a.arquivo_existe(pasta_lang + "/pt_br.lang") e a.arquivo_existe(pasta_lang + "/en_us.lang")){
			pt_br = a.abrir_arquivo(pasta_lang + "/pt_br.lang", a.MODO_LEITURA)
			en_us = a.abrir_arquivo(pasta_lang + "/en_us.lang", a.MODO_LEITURA)
			
			cadeia obj_lang_pt_br = ""
			enquanto(nao a.fim_arquivo(pt_br)){
				obj_lang_pt_br += a.ler_linha(pt_br)
			}
			lang_pt_br = o.criar_objeto_via_json("{" + obj_lang_pt_br + "}")

			cadeia obj_lang_en_us = ""
			enquanto(nao a.fim_arquivo(en_us)){
				obj_lang_en_us += a.ler_linha(en_us)
			}
			lang_en_us = o.criar_objeto_via_json("{" + obj_lang_en_us + "}")
		}
		senao{
			erro_arquivos()
		}
		
		se(nao erro_carregamento_arquivos){
			a.fechar_arquivo(arq_config)
			a.fechar_arquivo(arq_pontuacao)
			a.fechar_arquivo(pt_br)
			a.fechar_arquivo(en_us)
		}
	}
	funcao tutorial(){
		// Exibe o texto do tutorial at� que o jogador colete um ponto
		se(pontuacao == 0){
			g.definir_cor(0xffffff)
			g.definir_tamanho_texto(14.0)
			centralizar_texto(50, json("tutorial_1"))
			centralizar_texto(50 + g.altura_texto("A") + 5, json("tutorial_2"))
			centralizar_texto(50 + (g.altura_texto("A") + 5) * 2, json("tutorial_3"))
			centralizar_texto(50 + (g.altura_texto("A") + 5) * 3, json("tutorial_4"))
		}

		// Caso o jogador colete um ponto, o tutorial se finaliza
		senao{
			exibir_tutorial = falso
		}
	}
	funcao interface_atualizar_maior_pontuacao(){
		se(pontuacao > maior_pontuacao){
			// Atualiza a variavel
			maior_pontuacao = pontuacao
			
			// Atualiza a nova pontua��o no arquivo
			cadeia maior_pontos = maior_pontuacao + ""
			se(maior_pontuacao < 100 e maior_pontuacao < 10){
				maior_pontos = "00" + maior_pontos
			}
			senao se(maior_pontuacao < 100 e maior_pontuacao >= 10){
				maior_pontos = "0" + maior_pontos
			}
			arq_pontuacao = a.abrir_arquivo(pasta_config + "/pontuacao.config", a.MODO_ESCRITA)
			a.escrever_linha("\"maior_pontuacao\": \"" + maior_pontos + "\"", arq_pontuacao)
			a.fechar_arquivo(arq_config)
		}
	}
	funcao obter_fps(){
		// Aumenta a taxa de fps
		fps_taxa++

		// Obtem o tempo atual, quando necess�rio
		se(fps_obter_tempo){
			fps_tempo_inicio = u.tempo_decorrido()
			fps_obter_tempo = falso
		}

		// Detecta se j� se passou 1 segundo desde a obten��o do tempo atual
		se((u.tempo_decorrido() - fps_tempo_inicio) / 1000 >= 1){
			fps_atual = fps_taxa
			fps_taxa = 0
			fps_obter_tempo = verdadeiro
		}
	}
	funcao centralizar_texto(inteiro y, cadeia texto){
		inteiro x = 0
		x = (lar / 2) - (g.altura_texto("A") * tx.numero_caracteres(texto)) / 2
		g.desenhar_texto(x, y, texto)
	}
	funcao inteiro lingua_escolhida(){
		se(configuracoes_lingua == "Portugu�s (BR)"){
			retorne lang_pt_br
		}
		senao se(configuracoes_lingua == "English (US)"){
			retorne lang_en_us
		}
		senao{
			retorne lang_pt_br
		}
	}
	funcao cadeia json(cadeia propriedade){
		retorne o.obter_propriedade_tipo_cadeia(lingua_escolhida(), propriedade)
	}
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta se��o do arquivo guarda informa��es do Portugol Studio.
 * Voc� pode apag�-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 4195; 
 * @DOBRAMENTO-CODIGO = [36, 75, 79, 116, 129, 134, 139, 144, 153, 114, 99, 158, 167, 171, 165, 176, 180, 189, 183, 195, 201, 205, 210, 213, 216, 219, 204, 223, 259, 274, 248, 300, 306, 312, 297, 295, 326, 331, 336, 325, 324, 320, 349, 369, 347, 397, 401, 408, 412, 425, 428, 417, 373, 450, 455, 460, 465, 448, 444, 476, 499, 506, 509, 513, 516, 520, 523, 505, 530, 541, 556, 528, 575, 578, 581, 584, 573, 595, 594, 593, 602, 601, 600, 613, 609, 588, 620, 635, 642, 649, 633, 660, 663, 666, 669, 675, 678, 656, 689, 692, 685, 701, 707, 712, 724, 719, 728, 737, 733, 743, 753, 759, 748, 764, 768, 717, 777, 787, 775, 798, 801, 792, 791, 814, 820, 809, 826, 832, 835, 838, 831, 842];
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */