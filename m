From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] virtio_balloon: coding style fixes
Date: Thu, 15 Jan 2015 22:09:35 +0100
Message-ID: <54B82C8F.50103@gmail.com>
References: <1421321941-21111-1-git-send-email-mst@redhat.com>
	<20150115130642.GC7008@dhcp22.suse.cz>
	<20150115134412.GA23874@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150115134412.GA23874@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>, Michal Hocko <mhocko@suse.cz>
Cc: linux-api@vger.kernel.org, virtualization@lists.linux-foundation.org, mtk.manpages@gmail.com, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 01/15/2015 02:44 PM, Michael S. Tsirkin wrote:
> On Thu, Jan 15, 2015 at 02:06:42PM +0100, Michal Hocko wrote:
>> On Thu 15-01-15 13:39:06, Michael S. Tsirkin wrote:
>>> Most of our code has
>>> struct foo {
>>> }
>>>
>>> Fix two instances where balloon is inconsistent.
>>
>> I hate to complain but is it really necessary to post such patches to
>> linux-api?
> 
> Well it's human to err, so it seems wise to copy parties
> interested in the ABI/API whenever we are changing files under include/uapi.
> Whitespace changes should mostly be safe, but it's not unknown
> e.g. to include unrelated changes in the same commit by mistake.
> 
>> I thought the list was primarily for API related discussions.
> 
> Basically this line in MAINTAINERS
> 
> ABI/API
> L:      linux-api@vger.kernel.org
> F:      Documentation/ABI/
> F:      include/linux/syscalls.h
> F:      include/uapi/
> F:      kernel/sys_ni.c
> 
> normally means "send all patches affecting files under include/uapi/ to
> this list", does it not?
> 
> Wasn't this the intent?
> 
>> This is not the only mail sent here which doesn't fall into that
>> category IMO. It is far from low volume list for quite some time.
>>
>> Please let's get back low volume and API only discussion!
> 
> Maybe send patch dropping include/uapi/ from there,
> should help drive the volumes down?

Well, regardless of what it technically means, there's always going
to be scope for ambiguity, and that's where we differ from computers:
we can ask ourselves the question: will other human beings interested 
in the API/ABI care about this patch?

Thanks,

Michael (also saddened about increasing noise on linux-api)

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
