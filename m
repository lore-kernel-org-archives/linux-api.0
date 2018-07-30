From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] prctl: add PR_[GS]ET_KILLABLE
Date: Mon, 30 Jul 2018 12:17:00 +0200
Message-ID: <20180730101659.GA24781@redhat.com>
References: <20180730075241.24002-1-j@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180730075241.24002-1-j@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 07/30, Jürg Billeter wrote:
>
> This is required for job control in a shell that uses CLONE_NEWPID for
> child processes.

Could you explain in more details?

> +	case PR_SET_KILLABLE:
> +		if (arg2 != 1 || arg3 || arg4 || arg5)
> +			return -EINVAL;
> +		me->signal->flags &= ~SIGNAL_UNKILLABLE;

this needs spin_lock_irq(me->sighand->siglock).

Oleg.
