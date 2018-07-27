From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 29/38] vfs: syscall: Add fsconfig() for configuring and
 managing a context [ver #10]
Date: Fri, 27 Jul 2018 12:42:20 -0700
Message-ID: <CALCETrUXsOexKcj+K_v_bsW6DkGFgyNOaEs_qVOAcdNGBbEb2w@mail.gmail.com>
References: <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk>
 <153271287586.9458.6001928723332685410.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153271287586.9458.6001928723332685410.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 27, 2018 at 10:34 AM, David Howells <dhowells@redhat.com> wrote:
>  (*) fsconfig_set_path: A non-empty path is specified.  The parameter must
>      be expecting a path object.  value points to a NUL-terminated string
>      that is the path and aux is a file descriptor at which to start a
>      relative lookup or AT_FDCWD.
>
>  (*) fsconfig_set_path_empty: As fsconfig_set_path, but with AT_EMPTY_PATH
>      implied.
>
>  (*) fsconfig_set_fd: An open file descriptor is specified.  value must
>      be NULL and aux indicates the file descriptor.

Unless I'm rather confused, you have two or possibly three ways to
pass in an open fd.  Can you clarify what the difference is and/or
remove all but one of them?
