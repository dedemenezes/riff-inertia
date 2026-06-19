# frozen_string_literal: true

class MidiasController < ApplicationController
  def index
    redirect_to midias_fotos_e_videos_path
  end

  def fotos_e_videos
    render inertia: "Midias/FotosEVideos", props: {
      title: fotos_e_videos_label,
      activePage: fotos_e_videos_label,
      galleryLink: {
        label: "Ir para Flickr do Festival",
        href: "https://www.flickr.com/photos/festivaldorio/"
      },
      youtubeLink: {
        label: "Ir para YouTube do Festival",
        href: "https://www.youtube.com/@FestivaldoRio"
      },
      heroPhoto: {
        title: "Troféu Redentor",
        caption: "Troféu Redentor",
        imageUrl: nil
      },
      videos: [
        {
          title: "TV Festival",
          embedUrl: nil
        },
        {
          title: "Entrevistas do Festival",
          embedUrl: nil
        }
      ]
    }
  end

  def impressos
    render inertia: "Midias/Impressos", props: {
      title: impressos_label,
      activePage: impressos_label,
      printMaterials: [
        {
          title: "Revista de programação",
          cta: "Abrir PDF",
          pdfUrl: "#",
          coverTone: "purple"
        },
        {
          title: "Catálogo oficial",
          cta: "Abrir PDF",
          pdfUrl: "#",
          coverTone: "magenta"
        },
        {
          title: "Cartazes",
          cta: "Abrir PDF",
          pdfUrl: "#",
          coverTone: "orange"
        }
      ]
    }
  end

  private

  def fotos_e_videos_label
    I18n.t("navigation.media.fotos_e_videos")
  end

  def impressos_label
    I18n.t("navigation.media.impressos")
  end
end
