import React, { type FC } from 'react'
import { useParams } from 'react-router-dom'
import { css } from '../../../styled-system/css'
import { useProductQuery } from '../../generated/graphql'

const ProductPage: FC = () => {
  const { productId } = useParams<{ productId: string }>()
  if (!productId) return <div>Product not found</div>
  const { data, loading } = useProductQuery({
    variables: { id: productId },
  })
  const [addToCart] = useAddToCartMutation()

  if (loading) return <div>Loading...</div>

  const product = data?.product

  if (!product) return <div>Product not found</div>

  const handleAddToCart = async () => {
    try {
      await addToCart({
        variables: {
          productId: product.id,
          quantity: 1, // デフォルトで1個追加
        },
      })
      alert('Product added to cart')
    } catch (error) {
      console.error(error)
      alert('Failed to add product to cart')
    }
  }

  return (
    <div
      className={css({
        maxWidth: '800px',
        margin: '0 auto',
        padding: '16px',
        display: 'flex',
        flexDirection: 'column',
        gap: '16px',
      })}
    >
      <img
        src={product.imageUrl || 'https://img.skin/400x300'}
        alt={product.name}
        className={css({
          width: '100%',
          height: 'auto',
          borderRadius: '8px',
        })}
      />
      <h1 className={css({ fontSize: '24px', fontWeight: 'bold' })}>
        {product.name}
      </h1>
      <p className={css({ color: '#666', fontSize: '16px' })}>
        {product.description}
      </p>
      <p
        className={css({
          fontSize: '20px',
          fontWeight: 'bold',
        })}
      >
        ${product.unitPrice.toFixed(2)}
      </p>
      <p
        className={css({
          fontSize: '16px',
          color: product.stock > 0 ? 'green' : 'red',
        })}
      >
        {product.stock > 0 ? 'In Stock' : 'Out of Stock'}
      </p>
      {product.stock > 0 && (
        <button
          onClick={handleAddToCart}
          className={css({
            backgroundColor: '#4caf50',
            color: 'white',
            padding: '10px 20px',
            border: 'none',
            borderRadius: '4px',
            cursor: 'pointer',
            fontSize: '16px',
          })}
        >
          Add to Cart
        </button>
      )}
    </div>
  )
}

export default ProductPage
