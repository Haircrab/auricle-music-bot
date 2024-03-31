import { container, Listener } from '@sapphire/framework';

export class PlayerEvent extends Listener {
	public constructor(context: Listener.Context, options: Listener.Options) {
		super(context, {
			...options,
			emitter: container.client.player.events,
			event: 'connectionError'
		});
	}

	public run(queue, error) {
		console.log(`[${queue.guild.name}] Error emitted from the connection: ${error.message}`);
	}
}
