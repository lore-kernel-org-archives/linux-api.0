From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH 1/1] userfaultfd: require CAP_SYS_PTRACE for UFFD_FEATURE_EVENT_FORK
Date: Thu, 7 Nov 2019 00:54:59 -0800
Message-ID: <CAKOZuevhEXpMr49KmkBLEyMGsDz8WujKvOGCty8+p7cwVbmoXA@mail.gmail.com>
References: <1572967777-8812-1-git-send-email-rppt@linux.ibm.com>
 <1572967777-8812-2-git-send-email-rppt@linux.ibm.com> <CAKOZuev93zDGNPX+ySg_jeUg4Z3zKMcpABekUQvHA01kTVn4=A@mail.gmail.com>
 <CALCETrX=VmSjD6kLT6tuZQ4Efhc_13vZrw1mo4Z2iKqZTT-bzg@mail.gmail.com>
 <20191105162424.GH30717@redhat.com> <CAKOZuet=g++G+biSP5bU-Rppu6fykU1TVUDj20NapqAYQY4r9A@mail.gmail.com>
 <20191107083902.GB3247@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191107083902.GB3247@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Rapoport <rppt@linux.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Andy Lutomirski <luto@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Pavel Emelyanov <ovzxemul@gmail.com>, Tim Murray <timmurray@google.com>, Linux API <linux-api@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 7, 2019 at 12:39 AM Mike Rapoport <rppt@linux.ibm.com> wrote:
> On Tue, Nov 05, 2019 at 08:41:18AM -0800, Daniel Colascione wrote:
> > On Tue, Nov 5, 2019 at 8:24 AM Andrea Arcangeli <aarcange@redhat.com> wrote:
> > > The long term plan is to introduce UFFD_FEATURE_EVENT_FORK2 feature
> > > flag that uses the ioctl to receive the child uffd, it'll consume more
> > > CPU, but it wouldn't require the PTRACE privilege anymore.
> >
> > Why not just have callers retrieve FDs using recvmsg? This way, you
> > retrieve the message packet and the file descriptor at the same time
> > and you don't need any appreciable extra CPU use.
>
> I don't follow you here. Can you elaborate on how recvmsg would be used in
> this case?

Imagine an AF_UNIX SOCK_DGRAM socket. You call recvmsg(). You get a
blob of regular data along with some ancillary data. The ancillary
data may include some file descriptors or it may not. Isn't the UFFD
message model the same thing? You'd call recvmsg() on a UFFD and get
back a uffd_msg data structure. If that uffd_msg came with file
descriptors, these descriptors would be in ancillary data. If you
didn't reserve enough space for the message or enough space for its
ancillary data, the recvmsg() call would fail cleanly with MSG_TRUNC
or MSG_CTRUNC.

The nice thing about using recvmsg() for this purpose is that there's
tons of existing code for dealing with recvmsg()'s calling convention
and its ancillary data. You can, for example, use recvmsg out of the
box in a Python script. You could make an ioctl that also returned a
data blob plus some optional file descriptors, but if recvmsg already
does exactly that job and it's well-understood, why not just reuse the
recvmsg interface?

How practical is it to actually support recvmsg without being a
socket? How hard would it be to just become a socket? I don't know. My
point is only that *from a userspace API* point of view, recvmsg()
seems ideal.
