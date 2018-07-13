From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 24/32] vfs: syscall: Add fsopen() to prepare for
 superblock creation [ver #9]
Date: Fri, 13 Jul 2018 10:14:44 -0700
Message-ID: <CALCETrXS9ShF0k_tiFcBN6NY6ODCvhuZLh15VeHC5JUz9gWQuA@mail.gmail.com>
References: <CA+55aFzaTQJp6aHG_9+W2ShxeZncq7k9G3FkVFjFm7W=ECUiMw@mail.gmail.com>
 <CALCETrU3kbh-ZRHDj7-Asq+OH-35dQ2p_erpHpYUvN5+BdAoVQ@mail.gmail.com>
 <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
 <153126264966.14533.3388004240803696769.stgit@warthog.procyon.org.uk>
 <686E805C-81F3-43D0-A096-50C644C57EE3@amacapital.net> <22370.1531293761@warthog.procyon.org.uk>
 <7002.1531407244@warthog.procyon.org.uk> <338BC3C4-F3E7-48F0-A82E-2C7295B6640E@amacapital.net>
 <17749.1531429218@warthog.procyon.org.uk> <21131.1531488422@warthog.procyon.org.uk>
 <F80F34FD-CFD3-4A53-AECC-AEC8D9EF3EAE@amacapital.net> <26576.1531496428@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <26576.1531496428@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 13, 2018 at 8:40 AM, David Howells <dhowells@redhat.com> wrote:
> Andy Lutomirski <luto@amacapital.net> wrote:
>
>> > Whilst I'm at it, do we want the option of doing the equivalent of
>> > mountat()?  I.e. offering the option to open all the device files used by
>> > a superblock with dfd and AT_* flags in combination with the filename?
>> >
>>
>> Isn't that more or less what I was suggesting?
>
> Yes, you suggested that.  I'm asking if we actually need that.
>

Suppose some program in a container chroots itself and then tries to
create an fscontext backed by "/path/to/blockdev".  The syscall gets
intercepted by a container manager.  That manager now has a somewhat
awkward time of mounting the same fs, although it could use
"/proc/PID/root/path/to/blockdev", I suppose.  Even that approach has
some potentially awkward permission issues.  I would defer to the
people who actually write software like this, but I can imagine fds
being considerably easier to work with.
