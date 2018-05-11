From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 1/2 V2] hoist BTRFS_IOC_[SG]ET_FSLABEL to vfs
Date: Fri, 11 May 2018 10:32:19 -0400
Message-ID: <9F0DCA90-AD82-4179-B50A-F112CF966CCB@fb.com>
References: <d2979d75-5e45-b145-9ca5-2c315d8ead9c@redhat.com>
 <b8c7feca-68ce-b1a8-3a96-a99b50457a84@sandeen.net>
 <4a4f33c3-2173-9795-f4e4-1e9d338fd9a7@sandeen.net>
 <20180510191608.GR30522@ZenIV.linux.org.uk>
 <20180511141017.GZ6649@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20180511141017.GZ6649@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
To: David Sterba <dsterba@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 11 May 2018, at 10:10, David Sterba wrote:

> On Thu, May 10, 2018 at 08:16:09PM +0100, Al Viro wrote:
>> On Thu, May 10, 2018 at 01:13:57PM -0500, Eric Sandeen wrote:
>>> Move the btrfs label ioctls up to the vfs for general use.
>>>
>>> This retains 256 chars as the maximum size through the interface, 
>>> which
>>> is the btrfs limit and AFAIK exceeds any other filesystem's maximum
>>> label size.
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
>>> Reviewed-by: David Sterba <dsterba@suse.com>
>>
>> No objections (and it obviously ought to go through btrfs tree).
>
> I can take it through my tree, but Eric mentioned that there's a patch
> for xfs that depends on it. In this case it would make sense to take
> both patches at once via the xfs tree. There are no pending 
> conflicting
> changes in btrfs.

Probably easiest to just have a separate pull dedicated just for this 
series.  That way it doesn't really matter which tree it goes through.

-chris
