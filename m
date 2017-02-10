From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs
 hidepid= field
Date: Fri, 10 Feb 2017 15:44:50 -0800
Message-ID: <CAGXu5jKz5vo3NwKb_JmNyWDCP0izK=sxTL6Dx_KmYX=1NK+icA@mail.gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
 <1484572984-13388-3-git-send-email-djalal@gmail.com> <CAEiveUfDvSoW9Hy2Y_uxU2YQ+vR8OvXMqRhxAANTGG7QaQbJeg@mail.gmail.com>
 <CALCETrWEGLhEHO_6sTXreVyWFVsEeYmZSrLNNXx-ma5gd+nTQQ@mail.gmail.com>
 <CAEiveUcrSKS9PHAMpiDRChHHK5QDTPh6G63a0p3iXyYP8Wa27w@mail.gmail.com> <CALCETrWn-DpyR5JCGG0H2_yFxU3UHPHZHByXMc5uAxHgQDtnjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWn-DpyR5JCGG0H2_yFxU3UHPHZHByXMc5uAxHgQDtnjA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Djalal Harouni <tixxdz@gmail.com>, Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Lafcadio Wluiki <wluikil@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 18, 2017 at 3:35 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Jan 18, 2017 at 2:50 PM, Djalal Harouni <tixxdz@gmail.com> wrote:
>> Andy I don't follow here, no_new_privs is never cleared right ? I
>> can't see the corresponding clear bit code for it.
>
> I believe that unsharing userns clears no_new_privs.

Seriously? That's kind of ... weird. I mean, I guess you're
priv-confined in a way, but that seems fragile.

-Kees

-- 
Kees Cook
Pixel Security
