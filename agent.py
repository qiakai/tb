import os
import shlex
from pathlib import Path

from harbor.agents.installed.base import BaseInstalledAgent, ExecInput
from harbor.models.agent.context import AgentContext
from harbor.models.agent.name import AgentName


class Xcmd(BaseInstalledAgent):

    @staticmethod
    def name() -> str:
        return "X-CMD"

    @property
    def _install_agent_template_path(self) -> Path:
        return Path(__file__).parent / "install-xcmd.sh.j2"

    def populate_context_post_run(self, context: AgentContext) -> None:
        pass

    def create_run_agent_commands(self, instruction: str) -> list[ExecInput]:
        escaped_instruction = shlex.quote(instruction)

        # Determine provider and API key from model name
        if not self.model_name or "/" not in self.model_name:
            raise ValueError("Model name must be in the format provider/model_name")

        model = self.model_name

        api_key = os.environ.get("___X_CMD_HUB_TOKEN")

        if not api_key:
            raise ValueError(f"Not found apikey for X-CMD HUB")

        env = {
            "___X_CMD_HUB_TOKEN": api_key,  
        }

        return [
            ExecInput(
                command=(
                    f"x hub ai convo request --style chat --tool all --tool-force --without-repl --debug --model {model} {escaped_instruction} "
                    f"2>&1 | tee /logs/agent/xcmd.txt"
                ),
                env=env,
            )
        ]
