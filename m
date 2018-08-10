From: Dinesh Subhraveti <subhraveti@apporbit.com>
Subject: Re: [PATCH v4 0/4] seccomp trap to userspace
Date: Thu, 9 Aug 2018 17:31:57 -0700
Message-ID: <CAP4sa4+PTxniTjFWGJJjYFJXczgmUnsG2pQU7KuUdeERxxDnnQ@mail.gmail.com>
References: <20180621220416.5412-1-tycho@tycho.ws> <20180807024442.GA12274@cisco.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180807024442.GA12274@cisco.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Aug 6, 2018 at 7:44 PM Tycho Andersen <tycho@tycho.ws> wrote:
>
> Hi all,
>
> Dinesh Subhraveti has claimed that some part of this series might be
> patented. While he has not furnished me with anything to confirm this
> claim, I'll put this series on hold.

For the sake of everyone's clarity, there is no patent or intellectual
property issue here and we'd like to see this feature in the kernel.
I did indicate that there is a patent related to the mechanism
underlying this patch set but that is completely incidental to the
issue here.  We have filed that patent only for the purpose of defense
and have no interest or resources to go after infringements.  As such,
I spoke about the approach, it's value for networking and a few
possible ways of implementing it in the kernel at Linux Plumbers
Conference 2017.

As a contractor and a member of our team at AppSwitch (FKA Fermat),
Tycho Andersen helped implement a fully user space version of system
call trap mechanism based on seccomp / fd-passing and participated in
our team discussions about upstreaming a kernel version of the
feature.  Given that context, we were taken aback that he posted the
v1 patch set without letting us know and without any mention of
AppSwitch in the post even though he was still under contract at that
time.

In any case, please note that we will communicate with Tycho directly
regarding this matter going forward.

--
Dinesh Subhraveti
