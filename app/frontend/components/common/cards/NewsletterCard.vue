<script setup>
import { ref } from "vue"
import { BaseButton } from "@components/common/buttons"
import { Input } from "@components/ui/input"
import { useForm } from "@inertiajs/vue3"

const form = useForm({
  newsletter: {
    email: ""
  }
})

const validateEmail = (value) => {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return regex.test(value)
}

const emailError = ref("")

const submit = () => {
  if (!validateEmail(form.newsletter.email)) {
    emailError.value = "Por favor, insira um e-mail válido."
    return
  }

  emailError.value = ""
  form.post("/newsletters", {
    preserveScroll: true,
    onSuccess: () => {
      const el = document.getElementById("newsletter")
      if (el) el.scrollIntoView({ behavior: "smooth" })
      form.newsletter.email = ""
    }
  })
}

const cleanError = () => {
  if (form.newsletter.email === "") {
    emailError.value = ""
  }
}
</script>

<template>
  <div class="flex items-center justify-between mb-800" id="newsletter">
    <p class="text-header-regular-md w-[350px]">
      Receba nossas newsletters e fique por dentro das novidades do Festival do Rio →
    </p>
    <div class="w-[454px]">
      <form @submit.prevent="submit" @keyup.delete="cleanError" class="flex flex-col gap-400">
        <Input
          v-model="form.newsletter.email"
          type="email"
          name="newsletter[email]"
          placeholder="Seu email..."
          required
        />
        <p v-if="emailError" class="text-vermelho-600 text-sm -mt-2">
          {{ emailError }}
        </p>
        <BaseButton
          as="button"
          type="submit"
          size="md"
          variant="dark"
          class="w-[50%]"
          :disabled="form.processing"
        >{{ form.processing ? "Enviando..." : "Enviar" }}</BaseButton>
      </form>

    </div>
  </div>
</template>

<style scoped>
</style>
