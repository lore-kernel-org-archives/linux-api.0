From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/3] signalfd: add ability to choose a private or
	shared queue
Date: Thu, 7 Feb 2013 19:17:06 +0100
Message-ID: <20130207181706.GA8780@redhat.com>
References: <1358849741-9611-1-git-send-email-avagin@openvz.org> <1358849741-9611-3-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1358849741-9611-3-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>
List-Id: linux-api@vger.kernel.org

AOn 01/22, Andrey Vagin wrote:
>
> This patch is added two flags SFD_SHARED_QUEUE and SFD_PER_THREAD_QUEUE
> SFD_SHARED_QUEUE

I can't believe I am going to blame the naming ;) but these 2 do not look
"symmetrical"....

SFD_PRIVATE_QUEUE looks a little bit better to me. At least it is simpler
to type. But I am fine either way.

Oleg.
