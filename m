From: Eric B Munson <emunson@akamai.com>
Subject: Re: [PATCH V3 4/5] mm: mmap: Add mmap flag to request VM_LOCKONFAULT
Date: Tue, 21 Jul 2015 11:37:22 -0400
Message-ID: <20150721153722.GB5411@akamai.com>
References: <1436288623-13007-1-git-send-email-emunson@akamai.com>
 <1436288623-13007-5-git-send-email-emunson@akamai.com>
 <CAP=VYLq5=9DCfncJpQizcSbQt1O7VL2yEdzZNOFK+M3pqLpb3Q@mail.gmail.com>
 <55AD5CB9.4090400@ezchip.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55AD5CB9.4090400@ezchip.com>
Sender: linux-arch-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Vlastimil Babka <vbabka@suse.cz>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-arch <linux-arch@vger.kernel.org>, linux-api@vger.kernel.org, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Jul 2015, Chris Metcalf wrote:

> On 07/18/2015 03:11 PM, Paul Gortmaker wrote:
> >On Tue, Jul 7, 2015 at 1:03 PM, Eric B Munson<emunson@akamai.com>  wrote:
> >>>The cost of faulting in all memory to be locked can be very high when
> >>>working with large mappings.  If only portions of the mapping will be
> >>>used this can incur a high penalty for locking.
> >>>
> >>>Now that we have the new VMA flag for the locked but not present state,
> >>>expose it  as an mmap option like MAP_LOCKED -> VM_LOCKED.
> >An automatic bisection on arch/tile leads to this commit:
> >
> >5a5656f2c9b61c74c15f9ef3fa2e6513b6c237bb is the first bad commit
> >commit 5a5656f2c9b61c74c15f9ef3fa2e6513b6c237bb
> >Author: Eric B Munson<emunson@akamai.com>
> >Date:   Thu Jul 16 10:09:22 2015 +1000
> >
> >     mm: mmap: add mmap flag to request VM_LOCKONFAULT
>=20
> Eric, I'm happy to help with figuring out the tile issues.

Thanks for the offer, I think I have is sorted in V4 (which I am
checking one last time before I post).

Eric

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVrmcyAAoJELbVsDOpoOa9/LIQAKfvC7x2JgwcyjeVb/emAnku
OEKpBeDUe7W6lglYkz0zJKjDqQsPMqsEeQUqa/3D1zJJ/j5LStZ1VcSnWQf3vOL9
wzAE3TNSbBLN/guepYkUKLK09+/YAtrjbj0Kv4lMhcHXtHmcsdgEdrvz5guX2/jB
y0GXHGESyx+uNlrDgiqfrJM2mor7/gXdwQ9IXwB9uNTrEMUDo1Q+rAZdNDidmjZX
Ko+3GWUg1y5XewuU4PGOUkd49yWnlNCke55/vC9/ZD5uhpwo8LdKwMHxDlq9trAU
3qE3smKPEwImQtO8yI6hutkYCyj9Cz+2bQrBlWbxZjK+7uhTbiOzdWZyEt1p5b2B
1c3oi5R5h5lS1TEnNkvCmuBaA4M0vM3w5LVO1CzOlEM7h9zduOQXmmvOJqr6N0Al
eLG4/UPMnSbfjYh0ckDxhzbJS/2Kzgaa8itR/CAvGJfYapojorGO6cZTR45qzPga
qJDmfXhMRy7oIkdzXIU4yHmbzsGWjT3AcG3HUEWBQLXcgbI2CsdUz/ctQlJ0kv/g
Dyle+YYk0CEoNP5H8Ikc113x0TIHEeHJhKlh1G2XzxehF0IA3+7sMqRXbyGS4I7E
Gtw6pmAKbcFVDwDnn0moP3DYTzq2OyfhCmeQlJySlwpMK/OxjUUmq6iN3plfzpkD
Sksvg4KZsIFEzrhsm0Ow
=5+W3
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
