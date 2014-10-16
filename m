From: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the kernel
Date: Thu, 16 Oct 2014 10:09:04 -0700
Message-ID: <CALAqxLU05D8qQA47E77PiuuN7eVt66WEq1qn+PqdE-tpEUzFpw@mail.gmail.com>
References: <20141016124741.GA3832@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141016124741.GA3832@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org, Linux API <linux-api@vger.kernel.org>, Santosh Shilimkar <santosh.shilimkar@ti.com>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, Sumit Semwal <sumit.semwal@linaro.org>, Rebecca Schultz Zavin <rebecca@android.com>, Christoffer Dall <christoffer.dall@linaro.org>, Anup Patel <anup.patel@linaro.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 16, 2014 at 5:47 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> The Android binder code has been "stable" for many years now.  No matter

Well, ignoring the ABI break that landed in the last year. :)

> what comes in the future, we are going to have to support this API, so
> might as well move it to the "real" part of the kernel as there's no
> real work that needs to be done to the existing code.
>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>
> This was discussed in the Android miniconf at the Plumbers conference.
> If anyone has any objections to this, please let me know, otherwise I'm
> queueing this up for 3.19-rc1

So my main concerns/thoughts here are:

Who is going to maintain this? Has Arve agreed?  Are the Android guys
comfortable with the ABI stability rules they'll now face?  Currently
in the android space no one but libbinder should use the kernel
interface. Can we enforce that no one use this interface out-side of
android (To ensure its one of those "if the abi breaks and no one
notices..." edge cases)?

I'm still hopeful that a libbinder over kdbus will eventually pan out.
I still see having two core IPC mechanisms (even if the use cases are
different in style) as a negative, and I worry this might reduce
motivation to unify things at the lower level. Granted, such work can
still continue, but the incentives do change.

thanks
-john
