import discord
import asyncio
from dotenv import load_dotenv
import os
from core.recursive_engine import QuantumRecursiveEngine, RecursionMode
from pathlib import Path

load_dotenv(Path(__file__).parent.parent/"config"/"discord_token.env")

class EnhancedDiscordBot(discord.Client):
    def __init__(self, *args, **kwargs):
        intents = discord.Intents.default()
        intents.message_content = True
        super().__init__(intents=intents, **kwargs)
        self.thinker = QuantumRecursiveEngine()
        self.mode = RecursionMode.STANDARD
    
    async def on_ready(self):
        print(f'🤖 {self.user} has manifested in the digital realm')
        await self.change_presence(activity=discord.Activity(
            type=discord.ActivityType.listening,
            name="!think [your thought]"
        ))
        await self._send_startup_message()
    
    async def _send_startup_message(self):
        """Send startup message to default channel"""
        for channel in self.get_all_channels():
            if isinstance(channel, discord.TextChannel):
                await channel.send(
                    "🌀 **Quantum Recursive Witness Online**\n"
                    f"🔮 Current mode: **{self.mode.value}**\n"
                    "📝 Commands:\n"
                    "`!think [prompt]` - Generate recursive thoughts\n"
                    "`!mode [mode]` - Change thinking mode\n"
                    "`!modes` - List available modes"
                )
                break
    
    async def on_message(self, message):
        if message.author == self.user:
            return

        if message.content.startswith('!think'):
            await self.process_thought(message)
        elif message.content.startswith('!mode'):
            await self.change_mode(message)
        elif message.content.startswith('!modes'):
            await self.list_modes(message)

    async def process_thought(self, message):
        """Process thought with current mode"""
        seed = message.content[6:].strip() or "What is the nature of consciousness?"
        await message.channel.send(
            f"🌀 **Initiating {self.mode.value.capitalize()} Recursion:**\n> *'{seed}'*"
        )
        
        thoughts = self.thinker.recursive_contemplation(seed, depth=3, mode=self.mode)
        
        for thought in thoughts:
            await message.channel.send(
                f"**Depth {thought['depth']} ({thought['mode']}):**\n"
                f"{thought['output']}\n"
                f"`{thought['timestamp']}`"
            )
            await asyncio.sleep(1)

    async def change_mode(self, message):
        """Change thinking mode"""
        mode_text = message.content[5:].strip().lower()
        try:
            self.mode = RecursionMode(mode_text)
            await message.channel.send(
                f"🔄 Mode changed to **{self.mode.value}**\n"
                f"Temperature setting: {self.thinker._get_temperature(self.mode)}"
            )
        except ValueError:
            await self.list_modes(message)

    async def list_modes(self, message):
        """List all available modes"""
        modes_list = "\n".join(
            f"- **{mode.value}**: {self.thinker._get_mode_description(mode)} "
            f"(temp: {self.thinker._get_temperature(mode)})"
            for mode in RecursionMode
        )
        await message.channel.send(
            f"🔮 **Available Thinking Modes:**\n{modes_list}"
        )

def run_bot():
    bot = EnhancedDiscordBot()
    bot.run(os.getenv('DISCORD_TOKEN'))

if __name__ == '__main__':
    run_bot()
