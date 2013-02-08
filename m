From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/3] signalfd: add ability to choose a private or
	shared queue
Date: Fri, 8 Feb 2013 20:12:56 +0100
Message-ID: <20130208191256.GB13674@redhat.com>
References: <1358849741-9611-1-git-send-email-avagin@openvz.org> <1358849741-9611-3-git-send-email-avagin@openvz.org> <20130207181706.GA8780@redhat.com> <CAKgNAkjq3hVjYA3pVdBhyiFi1PbvXc_mOyvx_FaY67PmAifBOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKgNAkjq3hVjYA3pVdBhyiFi1PbvXc_mOyvx_FaY67PmAifBOQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org, criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>
List-Id: linux-api@vger.kernel.org

On 02/08, Michael Kerrisk (man-pages) wrote:
>
> I'd greatly prefer names that really say what these things are. Thus:
>
> SFD_PROCESS_QUEUE + SFD_THREAD_QUEUE
> or
> SFD_PROCESS_WIDE_QUEUE + SFD_PER_THREAD_QUEUE
> or
> SFD_PROCESS_Q + SFD_THREAD_Q
> or
> [some consistent variation of the above]

I am fine either way.

But again, perhaps ioctl/ptrace is better.

Oleg.

