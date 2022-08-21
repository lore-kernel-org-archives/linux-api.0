Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0170C32789
	for <linux-api@archiver.kernel.org>; Sun, 21 Aug 2022 10:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiHUK2J (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sun, 21 Aug 2022 06:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiHUK2I (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sun, 21 Aug 2022 06:28:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7B318394;
        Sun, 21 Aug 2022 03:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ezqnpfSoqTQDMJ+hJHVpOcv6CdCxoRGL+MI+YKi2ajc=; b=oGft0gECLBoMj2UBuNjBRRw7oU
        +dq00PAmbDXUBvlm8/tj+3wvQ6+u1mI4tCmpI7ekjaZJY5bZRNO9OebH9SJpV1ysh/OWtfztRfWPW
        oh7BrM3UcOp9ibf9eSMPU5DoNPWCirAlzoF7UBdHCRQtmm6dE/aZytFO5kBG+bAYbqLdyYZzrVtt/
        iuZP3zYaHC4+P7CXpDkHhx26k0MpnTHE/dEowsrIT+sGbKv23kjGfdNLUtoruLSmY1Y3DtZhd/9Hl
        3LYOd+8SlRhwWalnWFB/NWtwuYs86Tc9tyA9RmJoFdeb0dwyoEDgnWuoUSo1B+PY04MuuTWMM54Av
        EsSC0QFw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oPiBE-00D7rG-Sc; Sun, 21 Aug 2022 10:27:44 +0000
Date:   Sun, 21 Aug 2022 11:27:44 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, qemu-devel@nongnu.org,
        linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Steven Price <steven.price@arm.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>, luto@kernel.org,
        jun.nakajima@intel.com, dave.hansen@intel.com, ak@linux.intel.com,
        david@redhat.com, aarcange@redhat.com, ddutile@redhat.com,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>, mhocko@suse.com,
        Muchun Song <songmuchun@bytedance.com>,
        "Gupta, Pankaj" <pankaj.gupta@amd.com>
Subject: Re: [PATCH v7 00/14] KVM: mm: fd-based approach for supporting KVM
 guest private memory
Message-ID: <YwIIoFJrKPBXaRDW@casper.infradead.org>
References: <20220706082016.2603916-1-chao.p.peng@linux.intel.com>
 <ff5c5b97-acdf-9745-ebe5-c6609dd6322e@google.com>
 <20220818132421.6xmjqduempmxnnu2@box>
 <c6ccbb96-5849-2e2f-3b49-4ea711af525d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6ccbb96-5849-2e2f-3b49-4ea711af525d@google.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu, Aug 18, 2022 at 08:00:41PM -0700, Hugh Dickins wrote:
> tmpfs and hugetlbfs and page cache are designed around sharing memory:
> TDX is designed around absolutely not sharing memory; and the further
> uses which Sean foresees appear not to need it as page cache either.
> 
> Except perhaps for page migration reasons.  It's somewhat incidental,  
> but of course page migration knows how to migrate page cache, so
> masquerading as page cache will give a short cut to page migration,
> when page migration becomes at all possible.

I haven't read the patch series, and I'm not taking a position one way
or the other on whether this is better implemented as a shmem addition
or a shim that asks shmem for memory.  Page migration can be done for
driver memory by using PageMovable.  I just rewrote how it works, so
the details are top of my mind at the moment if anyone wants something
explained.  Commit 68f2736a8583 is the key one to look at.
