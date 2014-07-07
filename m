From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 00/11] Adding FreeBSD's Capsicum security framework
 (part 1)
Date: Mon, 7 Jul 2014 15:11:08 +0100
Message-ID: <CAHse=S8HutKUqjP-O=B4ByrpOnaNtdvpNxasp69sgG_U2No-4g@mail.gmail.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <53B51E81.4090700@redhat.com> <20140703183927.GA1629@google.com>
 <53B651C5.80602@redhat.com> <CAHse=S83APPfnEwO1fQbV_tNd=9zsAsZr42KbYM_He-c3C3P6A@mail.gmail.com>
 <53BA9094.9080401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53BA9094.9080401-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, qemu-devel <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 7, 2014 at 1:20 PM, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Il 07/07/2014 12:29, David Drysdale ha scritto:
>> Capsicum capabilities are associated with the file descriptor (a la
>> F_GETFD), not the open file itself -- different FDs with different
>> associated rights can map to the same underlying open file.
>
>
> Good to know, thanks.  I suppose you have testcases that cover this.
>
> Paolo

Yeah, there's lots of tests at:
  https://github.com/google/capsicum-test
(which is in a separate repo so it's easy to run against
FreeBSD as well as the Linux code); in particular
  https://github.com/google/capsicum-test/blob/dev/capability-fd.cc
has various interactions of capability FDs.
