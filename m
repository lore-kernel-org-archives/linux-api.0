Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7024CC83013
	for <linux-api@archiver.kernel.org>; Tue,  1 Dec 2020 18:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2758620870
	for <linux-api@archiver.kernel.org>; Tue,  1 Dec 2020 18:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729633AbgLASCW (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 1 Dec 2020 13:02:22 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:45392 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgLASCW (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 1 Dec 2020 13:02:22 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kk9xz-0034JV-Jl; Tue, 01 Dec 2020 11:01:31 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1kk9xy-00081x-2R; Tue, 01 Dec 2020 11:01:31 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     "Catangiu\, Adrian Costin" <acatan@amazon.com>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Alexander Graf <graf@amazon.de>,
        Mike Rapoport <rppt@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jann Horn <jannh@google.com>, Willy Tarreau <w@1wt.eu>,
        "MacCarthaigh\, Colm" <colmmacc@amazon.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list\:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Woodhouse\, David" <dwmw@amazon.co.uk>,
        "bonzini\@gnu.org" <bonzini@gnu.org>,
        "Singh\, Balbir" <sblbir@amazon.com>,
        "Weiss\, Radu" <raduweis@amazon.com>,
        "oridgar\@gmail.com" <oridgar@gmail.com>,
        "ghammer\@redhat.com" <ghammer@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Qemu Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>,
        "mpe\@ellerman.id.au" <mpe@ellerman.id.au>,
        linux-s390 <linux-s390@vger.kernel.org>,
        "areber\@redhat.com" <areber@redhat.com>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Andrey Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        "gil\@azul.com" <gil@azul.com>,
        "asmehra\@redhat.com" <asmehra@redhat.com>,
        "dgunigun\@redhat.com" <dgunigun@redhat.com>,
        "vijaysun\@ca.ibm.com" <vijaysun@ca.ibm.com>
References: <3E05451B-A9CD-4719-99D0-72750A304044@amazon.com>
        <300d4404-3efe-880e-ef30-692eabbff5f7@de.ibm.com>
        <da1a1fa7-a1de-d0e6-755b-dd587687765e@amazon.de>
        <20201119173800.GD8537@kernel.org>
        <1cdb6fac-0d50-3399-74a6-24c119ebbaa5@amazon.de>
        <106f56ca-49bc-7cad-480f-4b26656e90ce@gmail.com>
        <96625ce2-66c6-34b8-ef81-7c17c05b4c7a@amazon.com>
Date:   Tue, 01 Dec 2020 12:00:58 -0600
In-Reply-To: <96625ce2-66c6-34b8-ef81-7c17c05b4c7a@amazon.com> (Adrian Costin
        Catangiu's message of "Fri, 27 Nov 2020 20:26:02 +0200")
Message-ID: <87zh2xcso5.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kk9xy-00081x-2R;;;mid=<87zh2xcso5.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/R0Vga3FxvQqhqZmu6jrIe/AwE1gt5KtU=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v3] drivers/virt: vmgenid: add vm generation id driver
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

"Catangiu, Adrian Costin" <acatan@amazon.com> writes:

> - Background
>
> The VM Generation ID is a feature defined by Microsoft (paper:
> http://go.microsoft.com/fwlink/?LinkId=260709) and supported by
> multiple hypervisor vendors.
>
> The feature is required in virtualized environments by apps that work
> with local copies/caches of world-unique data such as random values,
> uuids, monotonically increasing counters, etc.
> Such apps can be negatively affected by VM snapshotting when the VM
> is either cloned or returned to an earlier point in time.

How does this differ from /proc/sys/kernel/random/boot_id?

> The VM Generation ID is a simple concept meant to alleviate the issue
> by providing a unique ID that changes each time the VM is restored
> from a snapshot. The hw provided UUID value can be used to
> differentiate between VMs or different generations of the same VM.

Does the VM generation ID change in a running that effectively things it
is running?

> - Problem
>
> The VM Generation ID is exposed through an ACPI device by multiple
> hypervisor vendors but neither the vendors or upstream Linux have no
> default driver for it leaving users to fend for themselves.
>
> Furthermore, simply finding out about a VM generation change is only
> the starting point of a process to renew internal states of possibly
> multiple applications across the system. This process could benefit
> from a driver that provides an interface through which orchestration
> can be easily done.
>
> - Solution
>
> This patch is a driver that exposes a monotonic incremental Virtual
> Machine Generation u32 counter via a char-dev FS interface.

Earlier it was a UUID now it is 32bit number?

> The FS
> interface provides sync and async VmGen counter updates notifications.
> It also provides VmGen counter retrieval and confirmation mechanisms.
>
> The generation counter and the interface through which it is exposed
> are available even when there is no acpi device present.
>
> When the device is present, the hw provided UUID is not exposed to
> userspace, it is internally used by the driver to keep accounting for
> the exposed VmGen counter. The counter starts from zero when the
> driver is initialized and monotonically increments every time the hw
> UUID changes (the VM generation changes).
> On each hw UUID change, the new hypervisor-provided UUID is also fed
> to the kernel RNG.

Should this be a hotplug even rather than a new character device?

Without plugging into udev and the rest of the hotplug infrastructure
I suspect things will be missed.

> If there is no acpi vmgenid device present, the generation changes are
> not driven by hw vmgenid events but can be driven by software through
> a dedicated driver ioctl.
>
> This patch builds on top of Or Idgar <oridgar@gmail.com>'s proposal
> https://lkml.org/lkml/2018/3/1/498


Eric
