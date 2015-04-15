From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] virtio_balloon: drop virtio_balloon_stat_modern
Date: Wed, 15 Apr 2015 12:45:03 +0930
Message-ID: <87h9sirsjs.fsf@rustcorp.com.au>
References: <1429005625-23181-1-git-send-email-mst@redhat.com>
	<20150414121327.4caacfba.cornelia.huck@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150414121327.4caacfba.cornelia.huck@de.ibm.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

Cornelia Huck <cornelia.huck@de.ibm.com> writes:
> On Tue, 14 Apr 2015 12:01:13 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
>
>> Looks like we are better off sticking with the misaligned stat struct,
>> to reduce the amount of virtio 1 specific code in balloon.  So let's do
>> it.
>> 
>> Add a detailed comment to reduce the chance people copy this bad example.
>> 
>> This also fixes a bug on BE architectures: tag should use
>> cpu_to_le16, not cpu_to_le32.
>> 
>> Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> ---
>> 
>> Just reposting so it's easier to apply.
>> Feel free to squash into previous patch if you think it's
>> neater.
>
> +1 for squashing from me. My A-b would also apply to the squashed patch.

Yes, I already squashed.

TBH, I would have squashed the next patches into one too, that simply
got rid of the virtio_device_is_legacy_only() function and all callers.

Thanks,
Rusty.
