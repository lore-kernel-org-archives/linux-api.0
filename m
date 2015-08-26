From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v7 3/6] mm: Introduce VM_LOCKONFAULT
Date: Wed, 26 Aug 2015 17:35:41 +0200
Message-ID: <55DDDCCD.5000908@suse.cz>
References: <20150812115909.GA5182@dhcp22.suse.cz>
 <20150819213345.GB4536@akamai.com> <20150820075611.GD4780@dhcp22.suse.cz>
 <20150820170309.GA11557@akamai.com> <20150821072552.GF23723@dhcp22.suse.cz>
 <20150821183132.GA12835@akamai.com> <20150825134154.GB6285@dhcp22.suse.cz>
 <20150825142902.GF17005@akamai.com> <20150825185829.GA10222@dhcp22.suse.cz>
 <20150825190300.GG17005@akamai.com> <20150826072016.GD25196@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150826072016.GD25196@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>, Eric B Munson <emunson@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 08/26/2015 09:20 AM, Michal Hocko wrote:
> On Tue 25-08-15 15:03:00, Eric B Munson wrote:
> [...]
>> Would you drop your objections to the VMA flag if I drop the portions of
>> the patch that expose it to userspace?
>>
>> The rework to not use the VMA flag is pretty sizeable and is much more
>> ugly IMO.  I know that you are not wild about using bit 30 of 32 for
>> this, but perhaps we can settle on not exporting it to userspace so we
>> can reclaim it if we really need it in the future?
>
> Yes, that would be definitely more acceptable for me. I do understand
> that you are not wild about changing mremap behavior.

+1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
