class Cinema < ApplicationRecord
  belongs_to :bairro
  belongs_to :edicao
  has_many :programacoes

  def filter_value
    id
  end

  def filter_display
    nome
  end

  def display_capacidade
    if !capacidade.nil? && !capacidade.empty?
      "#{capacidade} lugares"
    else
      "TDB"
    end
  end

  def filter_label
    I18n.t("filter.cinema")
  end

  def self.group_salas(cinemas)
    salas = cinemas.group_by { |cinema| cinema.nome.match(/\D*/)[0].strip }

    cinemas_and_salas = cinemas.map do |cinema|
      name = cinema.nome.match(/\D*/)[0].strip
      {
        name: name,
        salas: salas[name]
      }
    end.uniq

    cinemas_and_salas.map do |cas|
      result = {
        name: cas[:name],
        cinema: cas[:salas].first
      }

      if cas[:salas].length > 1
        result[:salas] = cas[:salas].map { |sala|
          {
            nome: "Sala #{sala.nome.match(/\d+/)[0].strip}",
            capacidade: sala.display_capacidade
          }
        }
      else
        result[:capacidade] = cas[:salas].first.display_capacidade
      end

      result
    end
  end
end
