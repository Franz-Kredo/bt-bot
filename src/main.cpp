#include <dpp/dpp.h>
#include <cstdlib>
#include <string>
#include <iostream>

#include "debug-helper.h"



const std::string BOT_TOKEN = [](){
    const char* tok = std::getenv("DISCORD_BOT_TOKEN");
    if(!tok) {
        std::cerr << "ERROR: DISCORD_BOT_TOKEN not set\n";
        std::exit(1);
    }
    return std::string(tok);
}();

int main() {
    disable_stdout(); // Disables stdout for gdb while debugging

    std::cout << "YOLO TIME!" << std::endl;

    // Combine the default intents with the privileged message_content intent
    uint64_t intents = dpp::i_default_intents | dpp::i_message_content;
    dpp::cluster bot(BOT_TOKEN, intents);

    bot.on_log(dpp::utility::cout_logger());

    bot.on_message_create([&bot](const dpp::message_create_t& event) {
        const auto& m = event.msg;
        std::cout << "[MSG] "
                  << m.author.username << '#' << m.author.discriminator
                  << " in channel " << m.channel_id
                  << " -> " << m.content
                  << std::endl;
    });

    bot.on_slashcommand([](const dpp::slashcommand_t& event) {
        if (event.command.get_command_name() == "ping") {
            const dpp::user& invoker = event.command.get_issuing_user();
            std::cout << "\n[SLASH] /ping invoked by "
                      << invoker.username << '#' << invoker.discriminator
                      << std::endl;
            event.reply("Pong!");
        }
    });

    bot.on_ready([&bot](const dpp::ready_t& event) {
        if (dpp::run_once<struct register_bot_commands>()) {
            bot.global_command_create(
                dpp::slashcommand("ping", "Ping pong!", bot.me.id)
            );
        }
    });

    bot.start(dpp::st_wait);
    return 0;
}