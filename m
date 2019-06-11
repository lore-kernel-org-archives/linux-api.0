From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH v7 03/14] x86/cet/ibt: Add IBT legacy code bitmap setup function
Date: Tue, 11 Jun 2019 09:24:03 +0200
Message-ID: <8736kgd1po.fsf@oldenburg2.str.redhat.com>
References: <20190606200926.4029-1-yu-cheng.yu@intel.com>
        <20190606200926.4029-4-yu-cheng.yu@intel.com>
        <20190607080832.GT3419@hirez.programming.kicks-ass.net>
        <aa8a92ef231d512b5c9855ef416db050b5ab59a6.camel@intel.com>
        <20190607174336.GM3436@hirez.programming.kicks-ass.net>
        <b3de4110-5366-fdc7-a960-71dea543a42f@intel.com>
        <34E0D316-552A-401C-ABAA-5584B5BC98C5@amacapital.net>
        <7e0b97bf1fbe6ff20653a8e4e147c6285cc5552d.camel@intel.com>
        <25281DB3-FCE4-40C2-BADB-B3B05C5F8DD3@amacapital.net>
        <e26f7d09376740a5f7e8360fac4805488b2c0a4f.camel@intel.com>
        <3f19582d-78b1-5849-ffd0-53e8ca747c0d@intel.com>
        <5aa98999b1343f34828414b74261201886ec4591.camel@intel.com>
        <0665416d-9999-b394-df17-f2a5e1408130@intel.com>
        <5c8727dde9653402eea97bfdd030c479d1e8dd99.camel@intel.com>
        <ac9a20a6-170a-694e-beeb-605a17195034@intel.com>
        <328275c9b43c06809c9937c83d25126a6e3efcbd.camel@intel.com>
        <92e56b28-0cd4-e3f4-867b-639d9b98b86c@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <92e56b28-0cd4-e3f4-867b-639d9b98b86c@intel.com> (Dave Hansen's
        message of "Mon, 10 Jun 2019 15:02:45 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>, Andy Lutomirski <luto@amacapital.net>, Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>
List-Id: linux-api@vger.kernel.org

* Dave Hansen:

> My assumption has always been that these large, potentially sparse
> hardware tables *must* be mmap()'d with MAP_NORESERVE specified.  That
> should keep them from being problematic with respect to overcommit.

MAP_NORESERVE pages still count towards the commit limit.  The flag only
disables checks at allocation time, for this particular allocation.  (At
least this was the behavior the last time I looked into this, I
believe.)

Not sure if this makes a difference here.

Thanks,
Florian
