Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.167.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793733226;
	b=IqO5yN/uNkdxBRv8HCXx7VQFNGPMBoggZCxSUo25d2jmEVn/Z4b8kvaDu4TxuYfqjzT+
	 WrmPrMcHR9EU0kOhbhcFTStN+c2c7Ow5Lwa1VPZjfUPfPSr3VQ4phjN/Y/3iIVAZK05hc
	 AKxfdwqIk4YikV2EjlVTPFgnlIvSORLFLEwbA7DjlvHNziyOR+CnqvAAUEqjP3IkhrYf5
	 uharM3QIf0edIVwtgOnZaFKOH7JP0G9nm2W7WWgYWCBzaMZDr9k2KADiuHSi5gw9aKbhr
	 96ItdRF55v/skQQUNE8zJ+eWWCh0NaqHfNe0J3QgIpBAANbEwWcChbuSsDcJSc0yAJw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793733226;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=EzON5iKuoC0TMaSslU3biH0v7oHgs1AmD4ygFPyRrek=;
	b=0RbBiLtUbnublv4NCY5qNhpf3Iswn4193Dm8hRVPT4nCKBiwZWCTF0mpHEIRhmMcdgV0
	 NFpZ/gMpGlphcf+7hHRItfrAYVz9AyFZ6fJJNkEkr4S4pqUDVMupn2PDIy3cz6soDLCHl
	 tMD7aoXbcAwa3dW2ax4JgSRfvanvfEOvcKhKKt5MqB8llAs0raU6nfItNOepMo34vih9F
	 8jnVX3bVj25BKPEIrJM7qfAXmSa2rz5E6890B42kBLdEtmWSwocosBBm6Ik486/ok/yij
	 fQfCAwYlMB0iVGtWqZrcS9ZPxpeTtTQdM7BdXofm0ViW2HcWdLfPc3Y/YJhfUWa3C3Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HIa4fMJ9;
	arc=fail smtp.remote-ip=209.85.167.51
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC1C606A31B
	for <linux-api@vger.kernel.org>; Tue,  3 Nov 2026 19:13:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CC1C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HIa4fMJ9
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5bfbc67991cso2986680e87.0
        for <linux-api@vger.kernel.org>; Tue, 03 Nov 2026 11:13:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793733224; cv=none;
        d=google.com; s=arc-20260327;
        b=PEIOxJw21RGoAOpHsBMny4U3lzFNoFJzz5JSMvmpnxLTUVwQ7EduW/7jRBD50Bk7Il
         tdmvtQllxY9gz76ca+QYlRbnT3RcdZAP/XWWlBjxhkEiCVwWYlHrhhBm4/32CHC8nCeG
         kj8rAiPqCLrHXOOGgmp/W6CoqGW9oFGNwNRgscLYfRNB1he96k21Y7NTxSOrd/K3wFAX
         v/rsHVoymvH4UjHUOE2B2tZtNTMtxi9cdJZpMjKHcpvyZAM3UgkynSbAw1NVHhU2GyLE
         ruFyhIc8OlhbJlnQHfRlPp02dCN4hH2z+zoR9AW3rh/49wYseSGmYuJ4WV6JwVvOlcTR
         psBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EzON5iKuoC0TMaSslU3biH0v7oHgs1AmD4ygFPyRrek=;
        fh=92xapQQpi6Nyr6DDd3fwhVqfLJ1crKOQJ70EMV79cY0=;
        b=EFEjCuwIGGK3yp5lzFrALw3rZSjZos+GUn85Yr9NFmblebgj1Nc9ZTA1xTSPANc/5S
         T4Vc5sbuBQBUm3414Bf3qGQzn79boBCQBg6/cO0qI4roLTKLge44MQojFJomfyfkvP9f
         4PvcfZo8FSr2ZB7rY5ABASzChDC1X4lC5a8P8PWcUYG1KdfzWT6YVENwfzZJtE/eQjEi
         Ev/WUvQ9wxJr+omdlnrbLKXQzANrSCBxZLBS6bo2ZuVByTMWbrzppqtgUdPIP1FZZeYE
         Njn5LBFJF3DDr9xBNIOgERlWrPzZ4vbzOBMjNS8yyx3yvRbtEzXD8Fvn5+jNN8v+6wND
         J9Ng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1793733224; x=1794338024; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EzON5iKuoC0TMaSslU3biH0v7oHgs1AmD4ygFPyRrek=;
        b=HIa4fMJ9fPv4CL9hPDHlpKceIdbrE0H+YbCDcwSkPUcmI+mvdreoHRB8VBVPCTGdws
         tpbDhtSMlghLw8CnXYb0Dl4859eP7mpe0lnqpTspVjxJS+hRhM8/kpGkzr8btLOQKKzA
         8tMDYPKRux3Ysl/1wru64ptug27+AQ7yuRpLu/kDZMpEYon1Mgj+vSH14a3nFCZjI4Rz
         he4VUySYQxykFyCh2rb6Hqjd5eeASICgfPrLw+eEChMUf2zMyAyGB8NGjvEMOx9sUF1F
         FwZeMxAhc+R9HFcayRRwEQEfpZRYssqmhPCF7Ux5V0KwasFcyD6bnp8sedlE8HJF/1C2
         ypgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793733224; x=1794338024;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EzON5iKuoC0TMaSslU3biH0v7oHgs1AmD4ygFPyRrek=;
        b=iv1i8W+i0BmsKKqfrdJvTQls6kp58Shv88BCUfOkyqWJVsoQ+DywbSUNFq/krRXa5B
         KKgf68W2cbmgXyYqufNCBUpYYsxQhqqRis05VwEoSatyFW3GSweeVtFNlSuDS+qlgk8F
         Lh8MKqaOrJYfjW3gJW/Iydrd6h0oh4XvKIewenJ8q+mLsV3/JxYZ5Xhuyls5k/9LFUJ/
         ukV0yB2lXq2/mZ+EiCaeoD8nDTHzmU1wIOZozvQs4MsQKeTQHodrWx0hyMl6iTZZ76HD
         PkyJpi+IoglDYKj+i4i/Zp1JQKBGBBFW0STk8pcb3TvddUSsj8Jlozduj+Ph8RC2sY0P
         a4EA==
X-Forwarded-Encrypted: i=1; AKwUvBzrPClDPRrj5pvKZUvwypGva0G3ZzJ+Flk/uwl2zp+Vg8+K4cadPxtyT1hO1JVv6DAYM4Qx1s8yssk=@vger.kernel.org
X-Gm-Message-State: APuU4Z/qcexFgJD1Hvoz2h1noh08rZ7zPz9dtaD1l9TCNT1d4VOBe1hb
	olRt71wlKkq6hX4+JFh76v0th6kyP8lR3gQKQscnhRPLW8H+0vDd8IMq2r8oNg8ky1vYz5Drx3V
	hw7sOqf+5GBKT/x9bFzVk4ZTNmeKHH+JUYIPAbeSE
X-Gm-Gg: AYBFou0GeeoqSbAfBrW7/Qi/jCb+7lJmAgNIYeh9b33kM2xtCWNxkwjJ2sGEs/Y92dz
	BCCTcsTe2WS3I6gKwzml3XjwpZle/kG4IBd+TAha5jMyT9KJXL85rBXNFrr7YvEj/m0ziGG9R9q
	F56pA+ND7SZNFrsBmH4EoCoXVC2hHwR/ZMCOpYfKowuDCPK+1kRrR/ZMF3BhBm+Z5bkg4pfModG
	7QBibFGwAvPVSbkkJip1kOVGh5TcifBQxPblWO1diA6DXdgHWV7O4b+SC/F9s5bBEQASnId2NIn
	e+gV7/YXjWXCJvGCnN/GAtgUYTn2i+qEsejHx5xY86u6wRN/bO2CjceXEraLaZoJ/wULOr3zRhV
	dfDCDAEFjEbeCE7B6MxezVVYsS1ep6AjvMV0=
X-Received: by 2002:a05:6512:a8b:b0:5bf:c700:3c3a with SMTP id
 2adb3069b0e04-5bfd9566849mr4561532e87.32.1793733224236; Tue, 03 Nov 2026
 11:13:44 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261012184642.558349-1-metze@samba.org> <20261021-kontakt-hauen-albern-9053a385d79e@brauner>
 <20261103080718.GA4109@lst.de>
In-Reply-To: <20261103080718.GA4109@lst.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 3 Nov 2026 11:13:32 -0800
X-Gm-Features: AclHuK_MZv5BAiVlGKrMnzCSAYEFT6lbx8aoY3ncjdnjuSg9lHyP-Vj45mKKe34
Message-ID: <CALCETrU0jXA7PJwsL059O+ewqTBopdopbDwMuH-Rb8M5yLdUew@mail.gmail.com>
Subject: Re: [PATCH] fs: add RWF_DIRECT for preadv2/pwritev2/io_uring to set
 IOCB_DIRECT per io
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Stefan Metzmacher <metze@samba.org>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, io-uring@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 12:11=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> On Wed, Oct 21, 2026 at 01:04:06PM +0200, Christian Brauner wrote:
> > On Mon, Oct 12, 2026 at 08:46:42PM +0200, Stefan Metzmacher wrote:
> > > It's useful to control this per io request instead of using O_DIRECT
> > > for the file descriptor.
> >
> > @Christoph thoughts on this?
>

> For some cases like
> mmap'ed I/O it will always introduce data corruption, but we'd at
> least make sure there's nothing exploitable.  And the direct user
> exposed flag would open lots of these exploit vectors.

I feel like we've set the bar quite low here, and I wish the bar were
higher.  Why does mmap need become incoherent when someone does an
O_DIRECT write?

Brain dump follows.

More generally, I've been contemplating page cache coherence for a few
days (unrelated to this), and I have not convinced myself that there
is any sort of principled concept of coherence that Linux implements,
and the closest I can come to being confident that nothing is
seriously broken is that I've only been able to find one seriously
broken thing recently (now fixed), and, worse I don't even have a
clean definition of what would constitute "seriously broken".  (Which
means that I can't, say, task an LLM with finding serious breaks or a
moderately compelling proof that there aren't any.)

Here's a bit of a taxonomy of page cache access types that I've come
up with from poking around at the kernel source [0]:

a) Plain buffered I/O (pread, pwrite, etc) -- I'm sure there is a lot
of nuance here, but I'm generally referring to I/O, via pagecache,
done in syscall or io_uring context on behalf of a user request.

b) Access via MAP_SHARED mmap or via unbroken-cow MAP_PRIVATE read,
whether this is actual ordinary user access or one of the weirder
cases like KVM that hits it by cheating a bit and using mmu_notifier.

c) O_DIRECT: not actually page cache, but it does *logically* touch
the same data that might be in page cache.

d) Access via pinned folio.  We have reads and writes, and we have
non-longterm and longterm pins.

In my mind (and I'm sure I've missed at least as many subtleties as
I've found), (a) is straightforward in the sense that the kernel can
take appropriate locks.  And the kernel takes locks that do *not* give
strict coherence but give a weaker sort, I think -- see below.

(b) can be fully coherent in the sense that the kernel can, and
hopefully does, invalidate mappings and flush the TLB as needed and
all access via mmap respects that (I hope -- I have not even tried to
review the various mmu_notifier users, but I sincerely hope they all
do it right).

(d) is gnarly: we have the xarray lock and the folio lock and various
pin bits, but we don't appear to have a lock that is safe to hold for
any extended period of time that preserves a folio's role as the
authoritative source of the contents of the part of the mapping it
covers.  In some sense, pinning a folio is like mmapping and faulting
in that same folio, except that the kernel can zap the PTEs and
invalidate the mapping from a different thread, but it cannot zap
folio pins.

(c) is supposed to be fast, and as far as I've found, the only
technical (as opposed to performance) reason it can't be coherent is
that there is no way for an O_DIRECT access to interact correctly with
the existence of a pinned folio.

But why can't an O_DIRECT access be coherent vs mmap?  (I'm assuming
we're talking about O_DIRECT writes, not reads.)  ISTM the kernel has
two ways to do it coherently: unmap the mapping (slow) or copy the
data being written into page cache and then write it from page cache
(differently slow).  If anyone mmaps a file and O_DIRECT-writes it
while they're touching the mapping at high frequency, I'm not sure
they deserve excellent performance, and I'd rather give coherence than
high performance incoherent behavior.


Anyway, I have a sort of proposed definition for what coherence might
mean -- call this "weak coherence":

For each address in the file, there are various accesses.  They happen
in an order -- think of this like a CPU memory model, not a strictly
linearizable order (if nothing else, mmaped accesses literally follow
the CPU's memory model).  But we broaden the memory model to pretend
that it applies to the logical file, not to the physical memory. The
implementation is weakly coherent if:

- Accesses via mmap obey the CPU memory model.

- Accesses via syscall or io_uring *including fixed buffers* obey the
CPU memory model, except that the access may be broken up into smaller
accesses that happen in arbitrary order, so long as they all happen
between the submission and the completion of the request.  This
includes direct I/O.

- Accesses via longterm folio pin follow the same rules as mmap.

- Accesses via shortterm folio pin are like syscalls: they happen some
time between acquisition and release of the pin but are not
necessarily ordered at the time that they are made by the CPU.  (This
is the weak part.)

I haven't come up with a reason that this would be impossible to
implement nicely, except that longterm folio pins would need a much
stricter locking scheme: anything that wants to detach a folio from an
address_space would need to wait for the pin to be released or
actively expedite the pin's release.

Is there a hard issue with O_DIRECT that I haven't thought of?

And someone would need to go through all the short-term pins in the
tree and make sure they're all actually okay with the weak form of
coherence.

I think there's at least one example that I think is questionable:
iov_iter_extract_user_pages, as reachable from FUSE and possibly
elsewhere.  Suppose there are two FUSE filesystems, A and B. A has a
file a and B has a file b. A process mmaps b, faults it in, and does
read(a_fd, b_ptr, 1), and the FUSE kernel code takes a short-term pin
on b_ptr's folio.  Then, before A's daemon responds, B's daemon
requests invalidation of b (via fuse_notify_inval_inode), which calls
invalidate_inode_pages2_range, which removes the folio from b's page
cache. Then A's daemon responds to the read via splice from a pipe,
causing the kernel to write to the short-term pinned folio, which goes
off into the void.

Is this a bug?  If B's invalidation happened because some external
actor logically wrote to *the entire area covered by the read*, then
arguably it's not -- under my coherence model, the read syscall can be
deemed to have occurred immediately before that write and the results
simply got overwritten.  But if B's invalidation happened for a
different reason (say an external write to a non-overlapping range),
then I think this behavior is incorrect.

Similarly, if there is just one FUSE and B is an ordinary filesystem,
then userspace can do read(a_fd, b_ptr, 1) and overlap it with an
O_DIRECT write to b at, say, offset 512, size 512.  If the FS accepts
that, then the folio gets detached and the read's update goes into the
void.


That last example seems more likely to hit if RWF_DIRECT shows up and
some library is like "hey, cool, now I can use our shiny atomic direct
I/O features in what used to be a buffered I/O path".  And maybe this
isn't a *security* bug, but it is an observable case where a simple
read() call appears to succeed but does not actually update the
destination buffer.  Ouch.


Anyway, that's my brain dump.


[0] Despite the fact that I got my start doing serious kernel work as
a result of writing a memory mapped database of sorts, I've never
actually stared at this part of the code before now...


--Andy


--=20
Andy Lutomirski
AMA Capital Management, LLC
