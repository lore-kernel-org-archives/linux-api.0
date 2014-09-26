From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 1/2] seccomp.2: document seccomp syscall
Date: Thu, 25 Sep 2014 18:29:29 -0700
Message-ID: <CALCETrVaYjrq0xBDouu9ZQ3Hm65Dmt2Uih4zscCGcDC+M89+qg@mail.gmail.com>
References: <1411685267-27949-1-git-send-email-keescook@chromium.org> <1411685267-27949-2-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411685267-27949-2-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 25, 2014 at 3:47 PM, Kees Cook <keescook@chromium.org> wrote:
> +.SH VERSIONS
> +This system call first appeared in Linux 3.16.
> +.\" FIXME Add glibc version

3.17?  (And remove FIXME?)

Otherwise I like it.

--Andy
