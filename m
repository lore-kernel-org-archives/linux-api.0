From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Thu, 30 Oct 2014 09:33:56 +0100
Message-ID: <4382138.U2ODUIQ55c@wuerfel>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414620056-6675-1-git-send-email-gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wednesday 29 October 2014 15:00:44 Greg Kroah-Hartman wrote:
>  drivers/misc/Kconfig                             |    1 +
>  drivers/misc/Makefile                            |    1 +
>  drivers/misc/kdbus/Kconfig                       |   11 +
>  drivers/misc/kdbus/Makefile                      |   19 +
>  drivers/misc/kdbus/bus.c                         |  450 ++++++
>  drivers/misc/kdbus/bus.h                         |  107 ++
>  drivers/misc/kdbus/connection.c                  | 1751 +++++++++++++++++++++
>  drivers/misc/kdbus/connection.h                  |  177 +++
>  drivers/misc/kdbus/domain.c                      |  477 ++++++
> 

One very high-level common:

Since this is going to be a very commonly used IPC mechanism, I don't
like the idea of stuffing it into drivers/misc.

How about putting it into drivers/kdbus or ipc/kdbus instead?

	Arnd
