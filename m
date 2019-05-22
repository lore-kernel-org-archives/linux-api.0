From: hpa@zytor.com
Subject: Re: [PATCH v3 2/2] initramfs: introduce do_readxattrs()
Date: Wed, 22 May 2019 09:18:36 -0700
Message-ID: <FAF78781-2684-4482-9D4D-445B91C15E97@zytor.com>
References: <20190517165519.11507-1-roberto.sassu@huawei.com> <20190517165519.11507-3-roberto.sassu@huawei.com> <CD9A4F89-7CA5-4329-A06A-F8DEB87905A5@zytor.com> <69ef1f55-9fc1-7ee0-371f-3dbc77551dc0@zytor.com> <a0afd58f-c682-66b5-7478-c405a179d72a@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a0afd58f-c682-66b5-7478-c405a179d72a@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Landley <rob@landley.net>, Roberto Sassu <roberto.sassu@huawei.com>, viro@zeniv.linux.org.uk
Cc: linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, arnd@arndb.de, james.w.mcmechan@gmail.com, niveditas98@gmail.com
List-Id: linux-api@vger.kernel.org

On May 17, 2019 7:16:04 PM PDT, Rob Landley <rob@landley=2Enet> wrote:
>On 5/17/19 4:41 PM, H=2E Peter Anvin wrote:
>> On 5/17/19 1:18 PM, hpa@zytor=2Ecom wrote:
>>>
>>> Ok=2E=2E=2E I just realized this does not work for a modular initramfs=
,
>composed at load time from multiple files, which is a very real
>problem=2E Should be easy enough to deal with: instead of one large file,
>use one companion file per source file, perhaps something like
>filename=2E=2Exattrs (suggesting double dots to make it less likely to
>conflict with a "real" file=2E) No leading dot, as it makes it more
>likely that archivers will sort them before the file proper=2E
>>>
>>> A side benefit is that the format can be simpler as there is no need
>to encode the filename=2E
>>>
>>> A technically cleaner solution still, but which would need archiver
>modifications, would be to encode the xattrs as an optionally nameless
>file (just an empty string) with a new file mode value, immediately
>following the original file=2E The advantage there is that the archiver
>itself could support xattrs and other extended metadata (which has been
>requested elsewhere); the disadvantage obviously is that that it
>requires new support in the archiver=2E However, at least it ought to be
>simpler since it is still a higher protocol level than the cpio archive
>itself=2E
>>>
>>> There's already one special case in cpio, which is the
>"!!!TRAILER!!!" filename; although I don't think it is part of the
>formal spec, to the extent there is one, I would expect that in
>practice it is always encoded with a mode of 0, which incidentally
>could be used to unbreak the case where such a filename actually
>exists=2E So one way to support such extended metadata would be to set
>mode to 0 and use the filename to encode the type of metadata=2E I wonder
>how existing GNU or BSD cpio (the BSD one is better maintained these
>days) would deal with reading such a file; it would at least not be a
>regression if it just read it still, possibly with warnings=2E It could
>also be possible to use bits 17:16 in the mode, which are traditionally
>always zero (mode_t being 16 bits), but I believe are present in most
>or all of the cpio formats for historical reasons=2E It might be accepted
>better by existing implementations to use one of these high bits
>combined with S_IFREG, I dont know=2E
>>
>>=20
>> Correction: it's just !!!TRAILER!!!=2E
>
>We documented it as "TRAILER!!!" without leading !!!, and that its
>purpose is to
>flush hardlinks:
>
>https://www=2Ekernel=2Eorg/doc/Documentation/early-userspace/buffer-forma=
t=2Etxt
>
>That's what toybox cpio has been producing=2E Kernel consumes it just
>fine=2E Just
>checked busybox cpio and that's what they're producing as well=2E=2E=2E
>
>Rob

Yes, TRAILER!!! is correct=2E Somehow I managed to get it wrong twice=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
