From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH V5] Allow compaction of unevictable pages
Date: Wed, 18 Mar 2015 15:40:38 +0100
Message-ID: <55098E66.7030609@suse.cz>
References: <1426267597-25811-1-git-send-email-emunson@akamai.com> <550332CE.7040404@redhat.com> <20150313190915.GA12589@akamai.com> <20150313201954.GB28848@dhcp22.suse.cz> <5506ACEC.9010403@suse.cz> <20150316134956.GA15324@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150316134956.GA15324-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 03/16/2015 02:49 PM, Eric B Munson wrote:
> On Mon, 16 Mar 2015, Vlastimil Babka wrote:
>
>> [CC += linux-api@]
>>
>> Since this is a kernel-user-space API change, please CC linux-api@.
>> The kernel source file Documentation/SubmitChecklist notes that all
>> Linux kernel patches that change userspace interfaces should be CCed
>> to linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, so that the various parties who are
>> interested in API changes are informed. For further information, see
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__www.kernel.org_doc_man-2Dpages_linux-2Dapi-2Dml.html&d=AwIC-g&c=96ZbZZcaMF4w0F4jpN6LZg&r=aUmMDRRT0nx4IfILbQLv8xzE0wB9sQxTHI3QrQ2lkBU&m=GUotTNnv26L0HxtXrBgiHqu6kwW3ufx2_TQpXIA216c&s=IFFYQ7Zr-4SIaF3slOZqiSP_noyva42kCwVRxxDm5wo&e=
>
> Added to the Cc list, thanks.
>
>>
>>
>> On 03/13/2015 09:19 PM, Michal Hocko wrote:
>>> On Fri 13-03-15 15:09:15, Eric B Munson wrote:
>>>> On Fri, 13 Mar 2015, Rik van Riel wrote:
>>>>
>>>>> On 03/13/2015 01:26 PM, Eric B Munson wrote:
>>>>>
>>>>>> --- a/mm/compaction.c
>>>>>> +++ b/mm/compaction.c
>>>>>> @@ -1046,6 +1046,8 @@ typedef enum {
>>>>>>   	ISOLATE_SUCCESS,	/* Pages isolated, migrate */
>>>>>>   } isolate_migrate_t;
>>>>>>
>>>>>> +int sysctl_compact_unevictable;
>>
>> A comment here would be useful I think, as well as explicit default
>> value. Maybe also __read_mostly although I don't know how much that
>> matters.
>
> I am going to sit on V6 for a couple of days incase anyone from rt wants
> to chime in.  But these will be in V6.
>
>>
>> I also wonder if it might be confusing that "compact_memory" is a
>> write-only trigger that doesn't even show under "sysctl -a", while
>> "compact_unevictable" is a read/write setting. But I don't have a
>> better suggestion right now.
>
> Does allow_unevictable_compaction sound better?  It feels too much like

For sorting purposes, maybe compact_unevictable_allowed?

> variable naming conventions from other languages which seems to
> encourage verbosity to me, but does indicate a difference from
> compact_memory.

If it sounds too awkward/long and nobody else has better suggestion, 
then just keep it as "compact_unevictable".
