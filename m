From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RESEND PATCH V2 0/3] Allow user to request memory to be locked
 on page fault
Date: Thu, 25 Jun 2015 07:26:14 -0700
Message-ID: <CALCETrW5LWgcuezfNDGYmivydsM2U36MLS6n1ardmLgsSrAdmQ@mail.gmail.com>
References: <1433942810-7852-1-git-send-email-emunson@akamai.com>
 <20150610145929.b22be8647887ea7091b09ae1@linux-foundation.org>
 <5579DFBA.80809@akamai.com> <20150611123424.4bb07cffd0e5bb146cc92231@linux-foundation.org>
 <557ACAFC.90608@suse.cz> <20150615144356.GB12300@akamai.com>
 <55895956.5020707@suse.cz> <20150625141638.GF2329@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150625141638.GF2329@akamai.com>
Sender: owner-linux-mm@kvack.org
To: Eric B Munson <emunson@akamai.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuahkh@osg.samsung.com>, Michal Hocko <mhocko@suse.cz>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-alpha@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux MIPS Mailing List <linux-mips@linux-mips.org>, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 25, 2015 at 7:16 AM, Eric B Munson <emunson@akamai.com> wrote:
> On Tue, 23 Jun 2015, Vlastimil Babka wrote:
>
>> On 06/15/2015 04:43 PM, Eric B Munson wrote:
>> >>
>> >>If the new LOCKONFAULT functionality is indeed desired (I haven't
>> >>still decided myself) then I agree that would be the cleanest way.
>> >
>> >Do you disagree with the use cases I have listed or do you think there
>> >is a better way of addressing those cases?
>>
>> I'm somewhat sceptical about the security one. Are security
>> sensitive buffers that large to matter? The performance one is more
>> convincing and I don't see a better way, so OK.
>
> They can be, the two that come to mind are medical images and high
> resolution sensor data.

I think we've been handling sensitive memory pages wrong forever.  We
shouldn't lock them into memory; we should flag them as sensitive and
encrypt them if they're ever written out to disk.

--Andy

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
