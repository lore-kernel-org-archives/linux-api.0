From: Florian Weimer <fweimer@redhat.com>
Subject: Re: pkeys: Reserve PKEY_DISABLE_READ
Date: Thu, 08 Nov 2018 21:23:35 +0100
Message-ID: <87bm6z71yw.fsf@oldenburg.str.redhat.com>
References: <877ehnbwqy.fsf@oldenburg.str.redhat.com>
 <2d62c9e2-375b-2791-32ce-fdaa7e7664fd@intel.com>
 <87bm6zaa04.fsf@oldenburg.str.redhat.com>
 <6f9c65fb-ea7e-8217-a4cc-f93e766ed9bb@intel.com>
 <87k1ln8o7u.fsf@oldenburg.str.redhat.com>
 <20181108201231.GE5481@ram.oc3035372033.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20181108201231.GE5481@ram.oc3035372033.ibm.com> (Ram Pai's
 message of "Thu, 8 Nov 2018 12:12:31 -0800")
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Ram Pai <linuxram@us.ibm.com>
Cc: linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, linuxppc-dev@lists.ozlabs.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

* Ram Pai:

> Florian,
>
> 	I can. But I am struggling to understand the requirement. Why is
> 	this needed?  Are we proposing a enhancement to the sys_pkey_alloc(),
> 	to be able to allocate keys that are initialied to disable-read
> 	only?

Yes, I think that would be a natural consequence.

However, my immediate need comes from the fact that the AMR register can
contain a flag combination that is not possible to represent with the
existing PKEY_DISABLE_WRITE and PKEY_DISABLE_ACCESS flags.  User code
could write to AMR directly, so I cannot rule out that certain flag
combinations exist there.

So I came up with this:

int
pkey_get (int key)
{
  if (key < 0 || key > PKEY_MAX)
    {
      __set_errno (EINVAL);
      return -1;
    }
  unsigned int index = pkey_index (key);
  unsigned long int amr = pkey_read ();
  unsigned int bits = (amr >> index) & 3;

  /* Translate from AMR values.  PKEY_AMR_READ standing alone is not
     currently representable.  */
  if (bits & PKEY_AMR_READ)
    return PKEY_DISABLE_ACCESS;
  else if (bits == PKEY_AMR_WRITE)
    return PKEY_DISABLE_WRITE;
  return 0;
}

And this is not ideal.  I would prefer something like this instead:

  switch (bits)
    {
      case PKEY_AMR_READ | PKEY_AMR_WRITE:
        return PKEY_DISABLE_ACCESS;
      case PKEY_AMR_READ:
        return PKEY_DISABLE_READ;
      case PKEY_AMR_WRITE:
        return PKEY_DISABLE_WRITE;
      case 0:
        return 0;
    }

By the way, is the AMR register 64-bit or 32-bit on 32-bit POWER?

Thanks,
Florian
