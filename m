From: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: reject MAP_SHARED_VALIDATE without new flags
Date: Wed, 27 Jun 2018 23:18:30 -0500
Message-ID: <52d82353-2746-269a-c1e3-e4aec4fbf0f9@redhat.com>
References: <60052659-7b37-cb69-bf9f-1683caa46219@redhat.com>
 <CA+55aFzeA7N3evSF2jKHu8JoTQuKDLCMKx7RiPhmym97-8HY7A@mail.gmail.com>
 <1e2ad827-6ff4-4b1e-c4d9-79ca4e432a6c@sandeen.net>
 <CA+55aFxs7Cc30fCiENw0R+XDJhUJ-w=z=NLLzYfT5gF2Qh-60Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CA+55aFxs7Cc30fCiENw0R+XDJhUJ-w=z=NLLzYfT5gF2Qh-60Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Sandeen <sandeen-+82itfer+wXR7s880joybQ@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, zhibli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 6/27/18 9:37 PM, Linus Torvalds wrote:
> On Wed, Jun 27, 2018 at 7:17 PM Eric Sandeen <sandeen-+82itfer+wXR7s880joybQ@public.gmane.org> wrote:
>>
>> What broke is that mmap(MAP_SHARED|MAP_PRIVATE) now succeeds without error,
>> whereas before it rightly returned -EINVAL.
> 
> You're still confusing *behavior* with breakage.
> 
> Yes. New *behavior* is that MAP_SHARED|MAP_PRIVATE is now a valid
> thing. It means "MAP_SHARED_VALIDATE".
> 
> Behavior changed.  That's normal. Every single time we add a system
> call, behavior changes: a system call that used to return -ENOSYS now
> returns something else.
> 
> That's not breakage, that's just intentional new behavior.

*shrug* semantics aside, the new behavior is out there in a public
API, so I guess there's nothing to do at this point other than
to document the change more clearly.  It's true that my patch could
possibly break existing users.

The man page is clearly wrong at this point, both in terms of the
error code section, and the claim that MAP_SHARED and MAP_PRIVATE
behave as described in POSIX (because POSIX states that these
two flags may not be specified together.)

-Eric
