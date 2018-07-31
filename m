From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH] prctl: add PR_[GS]ET_KILLABLE
Date: Tue, 31 Jul 2018 18:26:02 +0200
Message-ID: <CAG48ez1izZ+W_cPdNp3SOUwb_8YzwAYdSA6d=eqvaF=5+GKemA@mail.gmail.com>
References: <20180730075241.24002-1-j@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180730075241.24002-1-j@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: j@bitron.ch
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 30, 2018 at 10:01 AM J=C3=BCrg Billeter <j@bitron.ch> wrote:
>
> PR_SET_KILLABLE clears the SIGNAL_UNKILLABLE flag. This allows
> CLONE_NEWPID tasks to restore normal signal behavior, opting out of the
> special signal protection for init processes.
>
> This is required for job control in a shell that uses CLONE_NEWPID for
> child processes.
>
> This prctl does not allow setting the SIGNAL_UNKILLABLE flag, only
> clearing.
>
> Signed-off-by: J=C3=BCrg Billeter <j@bitron.ch>
> ---
[...]
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 38509dc1f77b..264de630d548 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
[...]
> +       case PR_SET_KILLABLE:
> +               if (arg2 !=3D 1 || arg3 || arg4 || arg5)
> +                       return -EINVAL;
> +               me->signal->flags &=3D ~SIGNAL_UNKILLABLE;
> +               break;

I don't have an opinion on this patchset otherwise, but should this
prctl maybe block PR_SET_KILLABLE if you're actually the real init
process? This seems like it could potentially lead to weird things.

This code in kernel/fork.c seems to rely on the fact that global init
is SIGNAL_UNKILLABLE, and probably also leads to weirdness if
container init is non-SIGNAL_UNKILLABLE:

        /*
         * Siblings of global init remain as zombies on exit since they are
         * not reaped by their parent (swapper). To solve this and to avoid
         * multi-rooted process trees, prevent global and container-inits
         * from creating siblings.
         */
        if ((clone_flags & CLONE_PARENT) &&
                                current->signal->flags & SIGNAL_UNKILLABLE)
                return ERR_PTR(-EINVAL);
