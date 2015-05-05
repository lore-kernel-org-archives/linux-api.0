From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] ipc/sem: 64bit union semun definition
Date: Tue, 05 May 2015 21:37:37 +0200
Message-ID: <2165666.hrkl3t0kHm@wuerfel>
References: <1430850523-7522-1-git-send-email-a22017@motorola.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430850523-7522-1-git-send-email-a22017-3WKxDLwmzFNWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: a22017-3WKxDLwmzFNWk0Htik3J/w@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tuesday 05 May 2015 11:28:43 a22017-3WKxDLwmzFNWk0Htik3J/w@public.gmane.org wrote:
> From: Ling-Juan Sun <a22017-3WKxDLwmzFNWk0Htik3J/w@public.gmane.org>
> 
> The member of semun semid_ds has new definition
> semid64_ds for 64bit architectures.
> 
> Signed-off-by: Ling-Juan Sun <a22017-3WKxDLwmzFNWk0Htik3J/w@public.gmane.org>
> 

Please describe in more detail what this is needed for. The way I
understood this, used space would always define union semun
to define semid_ds, but that would normally match the kernel's
semid64_ds.

Also, what is the connection with 64-bit architectures here?

	Arnd
