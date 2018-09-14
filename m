From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 11/11] UAPI: Check headers build for C++ [ver #2]
Date: Fri, 14 Sep 2018 11:10:35 +0200
Message-ID: <CAK8P3a3bSArr5-TowR5VTV1xbvO62ubiP0_6tJrFf=zqvEUeAg@mail.gmail.com>
References: <153622549721.14298.8116794954073122489.stgit@warthog.procyon.org.uk>
 <153622557736.14298.10350496216090814292.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153622557736.14298.10350496216090814292.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Linux API <linux-api@vger.kernel.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Joseph Myers <joseph@codesourcery.com>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 6, 2018 at 11:21 AM David Howells <dhowells@redhat.com> wrote:

> +
> +typedef __s8                   int8_t;
> +typedef __s16                  int16_t;
> +typedef __s32                  int32_t;
> +typedef __s64                  int64_t;
> +typedef __u8                   uint8_t;
> +typedef __u16                  uint16_t;
> +typedef __u32                  uint32_t;
> +typedef __u64                  uint64_t;
> +typedef long int               intptr_t;
> +typedef unsigned long int      uintptr_t;
> +typedef unsigned short         u_short;
> +typedef unsigned int           u_int;
> +typedef unsigned long          u_long;
> +typedef char                   *caddr_t;
> +
> +typedef __kernel_clockid_t     clockid_t;
> +typedef __kernel_ino_t         ino_t;
> +typedef __kernel_pid_t         pid_t;
> +typedef __kernel_sa_family_t   sa_family_t;
> +typedef __kernel_size_t                size_t;
> +typedef __kernel_uid_t         uid_t;
> +
> +typedef unsigned long          elf_greg_t;
> +typedef elf_greg_t             elf_gregset_t[1];
> +typedef unsigned long long     elf_fpregset_t[1];
> +typedef unsigned long long     elf_fpxregset_t[1];
> +
> +#define INT_MIN ((int)0x80000000)
> +#define INT_MAX ((int)0x7fffffff)
> +
> +extern size_t strlen(const char *);
> +extern void *memset(void *, int, size_t);
> +extern void *memcpy(void *, const void *, size_t);
> +extern __u16 ntohs(__u16);
> +extern __u16 htons(__u16);
> +extern __u32 ntohl(__u32);
> +extern __u32 htonl(__u32);
> +
> +typedef uint32_t               grant_ref_t;
> +typedef uint16_t               domid_t;
> +typedef unsigned long          xen_pfn_t;
> +
> +#define MSG_FIN         0x200
> +
> +typedef int SVGA3dMSPattern;
> +typedef int SVGA3dMSQualityLevel;
> +
> +struct sockaddr
> +{
> +       sa_family_t     sa_family;
> +       char            sa_data[14];
> +};
> +#define sockaddr_storage __kernel_sockaddr_storage

I think we need to reduce that list as much as we can. In
https://patchwork.ozlabs.org/patch/968814/, Joseph Myers pointed
out  header file (linux/elfcore.h) that simply cannot be included from
user space at all, because its dependencies cannot be met without
running into conflicting type definitions, and he would like to include
that file in order to automatically check that it's compatible with
the glibc version (I pointed out a couple of architectures on which
it is in fact incompatible right now).

In the list above, I see multiple classes of bugs that could be
addressed:

- references to identifiers that are only present in kernel internal
  headers: SVGA3dMSPattern, MSG_FIN, xen_pfn_t, ...
  I think these are all simple bugs, and we should either remove
  the references, or make sure the respective dependencies are
  included in the uapi headers as well, possibly renamed with
  a __kernel_ prefix to avoid clashing with user space headers.

- references to user space types that should use the uapi
  internal types: sockaddr_storage, clockid_t, uid_t, ...
  I think these just need to get the __kernel_prefix
  consistently as we did a few years ago. Note that using
  the headers otherwise is broken anyway when the types
  in libc are different from the ones in the kernel.

- standard types (uint32_t): either include the correct user
  space headers ifndef __KERNEL__ or use the kernel types

- standard functions (memcpy(), ntohs(), ...): These should
  already be handled in the headers by including the user space.
  If we missed any, we should probably do the same thing
  there.


       Arnd
