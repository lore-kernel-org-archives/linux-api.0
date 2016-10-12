From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v3 05/11] x86/tracing: fix compat syscall handling
Date: Wed, 12 Oct 2016 15:53:16 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1610121552220.8572@nanos>
References: <1476182576-15247-1-git-send-email-marcin.nowakowski@imgtec.com> <1476182576-15247-6-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476182576-15247-6-git-send-email-marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 11 Oct 2016, Marcin Nowakowski wrote:
> -/*
> - * Because ia32 syscalls do not map to x86_64 syscall numbers
> - * this screws up the trace output when tracing a ia32 task.
> - * Instead of reporting bogus syscalls, just do not trace them.
> - *
> - * If the user really wants these, then they should use the
> - * raw syscall tracepoints with filtering.

Why aren't you moving this information to the new place? It's valuable.

Thanks,

	tglx
