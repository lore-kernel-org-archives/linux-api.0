From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/7] Add a UFFD_SECURE flag to the userfaultfd API.
Date: Wed, 23 Oct 2019 16:15:12 -0400
Message-ID: <CAHk-=wgC-RGcTOrtY+ZQLdZ74EULBvD_+uiPToqhAAMNjAHM6g@mail.gmail.com>
References: <20191012191602.45649-1-dancol@google.com> <20191012191602.45649-4-dancol@google.com>
 <CALCETrVZHd+csdRL-uKbVN3Z7yeNNtxiDy-UsutMi=K3ZgCiYw@mail.gmail.com>
 <CAKOZuevUqs_Oe1UEwguQK7Ate3ai1DSVSij=0R=vmz9LzX4k6Q@mail.gmail.com>
 <CALCETrUyq=J37gU-MYXqLdoi7uH7iNNVRjvcGUT11JA1QuTFyg@mail.gmail.com>
 <CAG48ez3P27-xqdjKLqfP_0Q_v9K92CgEjU4C=kob2Ax7=NoZbA@mail.gmail.com> <20191023190959.GA9902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191023190959.GA9902@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Daniel Colascione <dancol@google.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Tim Murray <timmurray@google.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 23, 2019 at 3:10 PM Andrea Arcangeli <aarcange@redhat.com> wrote:
>
> That wouldn't break the ABI, no more than when if you boot a kernel
> built with CONFIG_USERFAULTFD=n.

What? No.

You're entirely incorrect.

If USEFAULTFD no longer works, and if people depend on it, then it's
breaking the ABI. End of story. No weaselwording of "as if built with
CONFIG_USERFAULTFD=n" allowed, no garbage.

Btw, the whole "breaking the ABI" is misleading wording anyway. It's
irrelevant. You can "break" the ABI all you want by changing
semantics, adding or removing features, or making it do anything else
- as long as nobody notices.

Because the only thing that matters is that it doesn't break any user
workflows. That's _all_ that matters, but it's a big deal, and it
means that your fantasy reading of what "ABI" means is irrelevant.
Just because there's a config option to turn something off, doesn't
mean that you can then claim that you can do whatever.

So your statement is nonsensical and pointless.

Please don't spread this kind of bogus claims.

                Linus
